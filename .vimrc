set nocompatible
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4

set showmatch
set tags=/home/gaines/workspace/Gemini/cable/trunk/platform/tags
set ruler
"set nohls

syntax on

set history=50

" expand tabs to spaces
"set expandtab

set nomodeline

"set timeoutlen=10
colorscheme darkblue

" turn off backgorund
hi Normal ctermbg=none

" line numbers
set nu

" dont wrap long lines
set nowrap

" scrolling offset (number of lines above or below cursor)
set scrolloff=3

" show typed command in status bar
set showcmd

" show filename in title bar
set title

" set path to current dir to :Explore any file (or :find or :sfind)
set path=$PWD/**

" hit F5 to show a list of buffers and select one

nnoremap <F5> :buffers<CR>:buffer<Space>
nnoremap <C-F9> :bdelete<CR>
nmap ;r :call OpenRelatedFile()<CR>
nmap ;b :buffers<CR>:buffer<Space>
nmap ;d :bdelete<CR>
nmap ;p :buffers<CR>:bdelete<Space>
nmap ;l :b#<CR>
"nmap ;m :!make<CR>
nmap ;m :!clear; make
nmap ;M :!clear; make && make install
nmap ;J :%!python -m json.tool<CR>
nmap ;t :TagbarToggle<CR>
nmap ;e :Explore **/
nmap ;S :'<,'>s/\([^"]\+\)"\([^"]\+\)"\(.*\)/\1XX_\2\3
nmap ;L :put ='std::cout << __FUNCTION__ << '<CR>
nmap ;E :put ='std::cerr << __FUNCTION__ << '<CR>


" no longer need to hit ctrl-w to move around panes
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" more natural split opening (whatever that means, from a website)
set splitbelow
set splitright

"removes all trailing whitespace
nmap ;w :%s/\(.\{-}\)\s*$/\1
"set wildcard completion

set wildchar=<Tab> wildmenu wildmode=full
set wildcharm=<C-Z>
" dont complain when switching buffers from an edited one

set hidden


" Generates a function header.  Parameter is the name of the function
" (or anything you want really)

function MakeFunctionHeader(name, ...)

    put ='/******************************************************************************'
    put =' *  ' . a:name
    put =' *'
    put =' *  Description: '
    put =' *'
    put =' *  Arguments:'
    put =' *'
    for i in a:000
        put =' *    - ' . i . ': '
        put =' *        '
    endfor
    put =' *'
    put ='******************************************************************************/'
    
                  
endfunction

command -nargs=+ FunctionHeader :call MakeFunctionHeader(<f-args>)

function MakeIncludeGuards(name)
    put ='#ifndef __' . a:name . '__'
    put ='#define __' . a:name . '__'
    put =''
    put =''
    put =''
    put =''
    put =''
    put =''
    put =''
    put =''
    put =''
    put =''
    put ='#endif'
endfunction

command -nargs=+ MakeGuards :call MakeIncludeGuards(<f-args>)

function DoReplace(log)
    execute "%s/std::cout/SCULog(vlog::LOG_" . a:log . ")/g"
    execute "%s/cout/SCULog(vlog::LOG_" . a:log . ")/g"
    execute "%s/std::cerr/SCUError(vlog::LOG_" . a:log . ")/g"
    execute "%s/cerr/SCUError(vlog::LOG_" . a:log . ")/g"
endfunction

command -nargs=+ AllReplace :call DoReplace(<f-args>)

" Generate a file header

function OpenRelatedFile()
    " see if end of file name is header (.h) or source (.cpp or .c)
    let s:fname = bufname("%")
    let s:extIndex = strridx(s:fname, ".")
    let s:ext = strpart(s:fname, s:extIndex)
    let s:rest = strpart(s:fname, 0, strlen(s:fname) - strlen(s:ext))
    let s:canOpen = 0

    if (s:ext == ".c" || s:ext == ".cpp")
        let s:ext = ".h"
        let s:fname = s:rest . s:ext
        let s:canOpen = filereadable(s:fname)
        if (s:canOpen == 0)
            let s:ext = ".hh"
            let s:fname = s:rest . s:ext
            let s:canOpen = filereadable(s:fname)
        endif
    elseif (s:ext == ".h" || s:ext == ".hh")
        "try cpp, if that doesnt exist, try c
        let s:ext = ".cpp"
        let s:fname = s:rest . s:ext
        let s:canOpen = filereadable(s:fname)
        if (s:canOpen == 0)
            let s:ext = ".c"
            let s:fname = s:rest . s:ext
            let s:canOpen = filereadable(s:fname)
        endif
    endif

    " attempt to open
    if (s:canOpen)
        execute "e " . s:fname
    else
        echo "Related file does not exist in this directory."
    endif

endfunction




