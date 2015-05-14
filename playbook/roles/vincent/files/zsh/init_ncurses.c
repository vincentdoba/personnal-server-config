/* Compiler avec l'option -lncurses */

/* Remplace #include <ncurses.h> */
extern void initscr();
extern void endwin();

int main()
{
   initscr();
   endwin();
   return 0;
}
