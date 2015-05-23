# (C) David Leadbeater, Blitzed Exploits team 2003.
# Licensed under GPLv2

# Usage: /akill [+time] (nick or host or mask) [reason]
# nick's host will be searched for in all channels, if no match then a /userhost
# will be sent

use strict;
use vars qw($VERSION %IRSSI);

use Irssi;
$VERSION = 1;
%IRSSI = (
    authors => 'David Leadbeater',
    contact => 'dg@blitzed.org',
    name    => 'akill',
    description   => 'Intelligent akill command',
    license => 'GPLv2',
    url     => 'http://irssi.dgl.cx/',
);

# Default time
Irssi::settings_add_str('akill', 'akill_time', '+6h');
# Default reason
Irssi::settings_add_str('akill', 'akill_reason', '');
# Irssi command to use, $mask, $time and $reason get replaced
Irssi::settings_add_str('akill', 'akill_cmd', 'quote os :akill add $time $mask $reason');

my $current = undef;

Irssi::command_bind 'akill' => sub {
   my($data, $server, $window) = @_;
   my($time, $mask, $reason) = split ' ', $data, 3;

   if(!$server) {
      print "No server!";
      return;
   }

   if(!$data) {
      print "No params!";
      return;
   }

   if($time !~ /\+/) {
   # Times must start with +, no time provided:
      $reason = "$mask $reason";
      $reason =~ s/\s+$//;
      $mask = $time;
      $time = Irssi::settings_get_str('akill_time');
   }


   if($mask !~ /@|\./) {
      # See if there is a matching nickname
      for my $chan($server->channels) {
         if(my $nick = $chan->nick_find($mask)) {
            my $host = $nick->{host};
            $host =~ s/.*@//;
            $mask = "*\@$host";
            last;
         }
      }
      # No, send a /userhost
      if($mask !~ /@/) {
         $server->redirect_event("userhost", 1, $mask, 0, undef, {
            "event 302" => "redir akill-userhost",
            "" => "event empty"
            } );
         $server->send_raw("USERHOST $mask");
         $current = { time => $time, mask => $mask, reason => $reason };
         return;
      }
   }elsif($mask =~ /\./ and $mask !~ /\@/) {
      $mask = "*\@$mask";
   }
   send_akill($server, { time => $time, mask => $mask, reason => $reason });

};

Irssi::signal_add "redir akill-userhost" => sub {
   my($server, $data) = @_;
   return unless defined $current;

   if($data =~ /^[^ ]+ :([^=]+)=[^@]+@([^ ]+)/) {
      my($nick, $host) = ($1, $2);
      if($nick =~ /\*$/) {
         print "That's an oper!";
         return;
      }
      
      if($current->{mask} ne $nick) {
         print "Nickname returned does not match?!";
         $current = undef;
         return;
      }
      
      $current->{mask} = "*\@$host";
      send_akill($server, $current);
      $current = undef;
   }else{
      $server->redirect_event("whowas", 1, $current->{mask}, 0, undef, {
         "event 314" => "redir akill-washost",
         "event 406" => "redir akill-nohost",
         "" => "event empty"
         } );
      $server->send_raw("WHOWAS $current->{mask}");
      return;
   }
};

Irssi::signal_add "redir akill-washost" => sub {
   my($server, $data) = @_;
   return unless defined $current;

   my($nick, $host) = (split / /, $data)[1, 3];
   if($current->{mask} ne $nick) {
      print "Nickname returned does not match?!";
      $current = undef;
      return;
   }

   $current->{mask} = "*\@$host";
   send_akill($server, $current);
   $current = undef;
};

Irssi::signal_add "redir akill-nohost" => sub {
   return unless defined $current;
   print CRAP "Host for %_$current->{mask}%_ not found!";
   $current = undef;
};

sub send_akill {
   my($server, $params) = @_;
   my $cmd = Irssi::settings_get_str('akill_cmd');
   $params->{reason} ||= Irssi::settings_get_str('akill_reason');
   $cmd =~ s/\$([a-z]+)/$params->{$1}/g;
   print CRAP "\%RAkilling\%n %_$params->{mask}%_";
   $server->command($cmd);
}
