filetype plugin indent on

autocmd VimEnter * Goyo 120
cnoreabbrev g Goyo

function! s:goyo_enter()
	set number
	highlight LineNr ctermfg=234 ctermbg=None
	let b:quitting = 0
	let b:quitting_bang = 0
	autocmd QuitPre <buffer> let b:quitting = 1
	cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
endfunction

function! s:goyo_leave()
	" Quit Vim if this is the only remaining buffer
	if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
		if b:quitting_bang
			qa!
		else
			qa
		endif
	endif
endfunction

autocmd! User GoyoEnter call <SID>goyo_enter()
autocmd! User GoyoLeave call <SID>goyo_leave()

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
hi Normal ctermbg=none

" Return to last line when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif
