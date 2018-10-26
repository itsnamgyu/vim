filetype plugin indent on

" Auto goyo
au VimEnter * Goyo 120
" Goyo resize on window resize
au VimResized * if exists('#goyo') | exe "normal \<c-w>=" | endif
" Return to last line
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

function! Goyo_enter()
	set number
	let b:quitting = 0
	let b:quitting_bang = 0
	autocmd QuitPre <buffer> let b:quitting = 1
	cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
	if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endfunction

" Patch to support return to last lien w/ goyo
ca wq :w<cr>:call Quit()<cr>
ca q :call Quit()<cr>
ca qq :call ForceQuit()<cr>

function Quit()
    if exists('#goyo')
        Goyo
    endif
    quit
endfunction

function ForceQuit()
    if exists('#goyo')
        Goyo
    endif
    quit!
endfunction

cnoreabbrev go Goyo
autocmd! User GoyoEnter call Goyo_enter()

set number
set autoindent
set smartindent

set tabstop=4
set shiftwidth=4
set hlsearch
set noexpandtab

set viminfo='20,<1000,s1000
set ruler

colorscheme diablo3
syntax on

autocmd BufNewFile *.c :normal incStd
autocmd BufWritePost *.c !gcc -o test_compile % ; rm test_compile

command Flake !flake8 --max-line-length 120 %

noremap! fj <Esc>
noremap incStd i#include <stdio.h><cr><cr><esc>
noremap include :call Include()<cr>
noremap main iint main(void) {<enter>}<esc>Oreturn 0;<esc>O<esc>k:call StartAtNewLine()<cr>
noremap newF :call NewFunction()<cr>
noremap for :call For()<cr>
noremap ] /}<cr>kA<cr>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

function PutA()
	call feedkeys("a")
endfunction

function Include()
	let lib = input("Enter the library you want to include: ")
	execute "normal! mZG?#include\<cr>o#include " .lib. "\<esc>'Z"
endfunction

function CompileAndRun()
	execute "normal! :w\<cr> :! gcc \%\<cr> :! ./a.out\<cr>"
endfunction

function StartAtNewLine()
	call feedkeys("A")
	call feedkeys("\<cr>")
endfunction

function NewFunction()
	let functionString = input("Enter the function string: ")
	execute "normal! G/main\<cr>O\<esc>O" . functionString . ";\<esc>Go\<cr>" . functionString . " {\<cr>}\<esc>k"
	call StartAtNewLine()
endfunction

function For()
	let counter = input("Enter counter: ")
	let n = input("Enter limit: ")
	execute "normal! ddOfor (int " .counter. " = 0; " .counter. " < " . n . "; ++" .counter. ") {\<cr>}\<esc>k"
	call StartAtNewLine()
endfunction

" Disable theme background color
hi! Normal ctermbg=none
hi! LineNr ctermfg=239 ctermbg=None
hi! SignColumn ctermbg=none
" Remove tilde [~]
hi! EndOfBuffer ctermbg=none ctermfg=black
hi! NonText ctermbg=none ctermfg=black

" Remember last location in file
if has("autocmd")
endif

" Vim scrolling on iterm2
set mouse=a
if has("mouse_sgr")
    set ttymouse=sgr
else
    set ttymouse=xterm2
end
