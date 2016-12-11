"   Vundle
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'terryma/vim-smooth-scroll'
Plugin 'surround.vim'
Plugin 'a.vim'
Plugin 'kien/ctrlp.vim'
"Plugin 'gerw/vim-latex-suite'
Plugin 'jcf/vim-latex'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

let &scrolloff = &scroll/4
set t_Co=16
set background=dark
colo breeze
syntax on


set noexpandtab
set title
set tabstop=2
set shiftwidth=2
" set softtabstop=2
"
set number
set hlsearch
set nofoldenable
set cursorline

" hi clear CursorLine
" augroup CLClear
" autocmd! ColorScheme * hi CursorLine
" augroup END

"	augroup CursorLine
"	  au!
"	  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
"	  au WinLeave * setlocal nocursorline
"	augroup END

highlight CursorLine cterm=NONE ctermbg=234
highlight Search cterm=NONE ctermbg=037 ctermfg=017

highlight cSpaceError ctermbg=Black

augroup CursorLine
	au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

highlight Pmenu ctermbg=lightblue
highlight Pmenusel ctermbg=lightgreen

highlight colorcolumn ctermbg=Darkcyan

highlight SpellBad ctermbg=Darkcyan


autocmd FileType tex setlocal spell spelllang=en_us,sv
" g:Tex_CompileRule_pdf
" autocmd FileType tex map <silent> <c-o> :w <bar> :!pdflatex %<CR>
filetype plugin on
set grepprg=grep\ -nH\ $*
filetyp indent on
" set shellslash
let g:tex_flavor='latex'
let g:Tex_GotoError=0
let c_space_errors=1


imap <C-g> <Plug>IMAP_JumpForward
nmap <C-g> <Plug>IMAP_JumpForward

nnoremap <silent> <c-j> :call smooth_scroll#down(1, 1, 1)<CR>
nnoremap <silent> <c-k> :call smooth_scroll#up(1, 1, 1)<CR>
nnoremap <silent> <c-u> :call smooth_scroll#up(&scroll, 15, 1)<CR>
nnoremap <silent> <c-d> :call smooth_scroll#down(&scroll, 15, 1)<CR>
nnoremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 10, 1)<CR>
nnoremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 10, 1)<CR>

nnoremap <C-c> :noh<CR>

autocmd FileType tex nnoremap <silent> <c-j> gj
autocmd FileType tex nnoremap <silent> <c-k> gk
autocmd FileType tex nnoremap <silent> <c-h> b
autocmd FileType tex nnoremap <silent> <c-l> w

nnoremap <silent> ö za
nnoremap <silent> Ö zA

" Alternate between .c and .h files
noremap <silent> <c-a> :A<CR>

autocmd FileType cpp set keywordprg=cppman
autocmd FileType cpp set foldmethod=syntax
autocmd FileType c set foldmethod=syntax

