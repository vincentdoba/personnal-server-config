" Vim color file

set background=dark
hi clear
if exists("syntax_on")
    syntax reset
endif

let g:colors_name="mine"

hi Comment	cterm=none ctermfg=darkgrey
hi Constant	cterm=bold ctermfg=white
hi Directory    cterm=none ctermfg=darkcyan
hi Error	cterm=none ctermfg=white ctermbg=red
hi ErrorMsg	cterm=none ctermfg=black ctermbg=red
hi Identifier   cterm=none ctermfg=darkcyan
hi MoreMsg      cterm=bold ctermfg=darkgreen
hi Pmenu        cterm=none ctermfg=black ctermbg=lightgrey
hi PmenuSel     cterm=none ctermfg=black ctermbg=darkcyan
hi PreProc	cterm=none ctermfg=blue
hi Question     cterm=bold ctermfg=darkgreen
hi Special	cterm=bold ctermfg=red
hi Statement    cterm=bold ctermfg=yellow
hi Title        cterm=bold ctermfg=magenta
hi Type	        cterm=none ctermfg=darkgreen
hi Todo	        cterm=none ctermfg=black ctermbg=brown
hi Visual	cterm=none ctermfg=black ctermbg=white
hi WarningMsg   cterm=none ctermfg=red

" Common groups that link to default highlighting.
" You can specify other highlighting easily.
hi link String	        Constant
hi link Character	Constant
hi link Number	        Constant
hi link Boolean	        Constant
hi link Float		Number
hi link Function	Identifier
hi link Conditional	Statement
hi link Repeat	        Statement
hi link Label		Statement
hi link Operator	Statement
hi link Keyword	        Statement
hi link Exception	Statement
hi link Include	        PreProc
hi link Define	        PreProc
hi link Macro		PreProc
hi link PreCondit	PreProc
hi link StorageClass	Type
hi link Structure	Type
hi link Typedef	        Type
hi link Tag		Special
hi link SpecialChar	Special
hi link Delimiter	Special
hi link SpecialComment  Special
hi link Debug		Special
hi link Ignore          Comment

