"" Leaders
" q   : :q<Cr>
" f   : FZF Files
" g   : FZF GFiles
" r   : FZF Rg
" b   : FZF Buffers
" s   : Slime Send Paragraph/Region to Repl
" l   : SLime send current line to Repl
" i   : IF 'python' Toggle ipython3 Terminal
"     : IF 'go' then go-run
" y   : Yank to system clipboard
" p   : Paste from system clipboard
" w   : Quick Save
" q   : Quick quite
" cd  : cd to current directory
" t   : Toggle 'default' terminal
" d   : DogeGenerate
" v   : vsplit
" u   : undo

"" F# Keys
" F2  : Toggle netrw
" F3  : Toggle search highlight
" F5  : Toggle Ale gutter
" F6  : MarkdownPreview
" F7  : Toggle Indentline
" F10 : Check syntax group name
" F12 : Toggle Maximize current window

"" Movements
" ]h  : GitGutter next hunk
" [h  : GitGutter prev hunk
" ]l  : Ale next lint warning/error
" [l  : Ale prev lint warning/error

""" PLUGIN
""""""""""""""""""""""""""""""""""""""""""""""""""""
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source ~/.config/nvim/init.vim
endif

call plug#begin('~/.local/share/nvim/plugged')

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'justinmk/vim-sneak'
Plug 'sainnhe/gruvbox-material'
Plug 'unblevable/quick-scope'

" IDE
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-vinegar'						" better newrw
Plug 'tpope/vim-abolish'                        " for its coersion
Plug 'dense-analysis/ale'
Plug 'jpalardy/vim-slime'						" REQUIRES nevim > 0.3
Plug 'psf/black', { 'for': 'python' }           " To make sure pip and vim has the same black version: pip install --upgrade git+https://github.com/psf/black.git
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'hashivim/vim-terraform', { 'for': 'terraform' }
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go' }

" non essential
Plug 'kkoomen/vim-doge'							" documentation generator
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'                       " blame, Gbrowse & Gdiffsplit
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'szw/vim-maximizer'
Plug 'vim-airline/vim-airline'
Plug 'yggdroot/indentline'

call plug#end()

" true color
set termguicolors
" for quick-scope, needs to be before colorscheme
augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
augroup END

colorscheme gruvbox-material

"" fzf
" install fd-find and ripgrep
noremap <leader>f :Files<Cr>
noremap <leader>g :GFiles<Cr>
noremap <leader>r :Rg<Cr>
noremap <leader>b :Buffers<Cr>

let g:fzf_layout = { 'down': '~20%' }
let g:fzf_history_dir = '~/.local/share/fzf-hist'	" enable history browsing with Ctrl+P/N

"" sneak
let g:sneak#label = 1                           " EasyMotion behaviour

"" quick-scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

"" ale
let g:ale_linter_aliases = {'yaml': ['cloudformation', 'yaml', 'j2']}
let g:ale_linters = {
    \ 'python': ['flake8'],
    \ 'go': ['golint'],
    \ 'terraform': ['tflint'],
    \ 'sh': ['language_server'],
    \ }
let g:ale_completion_enabled = 0
let g:ale_python_flake8_options = '--ignore=E501'	" ignore 'lines too long' error
map <F5> :ALEToggle<Cr>
"" coc key map overwrite this
" map <silent> ]l <Plug>(ale_next_wrap)
" map <silent> [l <Plug>(ale_previous_wrap)

"" coc
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics/linting
nmap <silent> [l <Plug>(coc-diagnostic-prev)
nmap <silent> ]l <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gv :call CocAction('jumpDefinition', 'vsplit')<Cr>
" nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')


"" terraform
let g:terraform_align=1
let g:terraform_fmt_on_save=1


"" markdown preview
let g:mkdp_browser = 'firefox'
nmap <F6> <Plug>MarkdownPreview

"" doge
let g:doge_doc_standard_python = 'google'
noremap <leader>d :DogeGenerate<Cr>

"" airline
let g:airline_section_c = 'b%n %<%F%*%m%*'      " buffer number, full path and modifier
let g:airline_section_z = 'c:%v L:%L'
let g:airline#extensions#ale#enabled = 1

"" maximizer
let g:maximizer_default_mapping_key = '<F12>'

"" indentline
let g:indentLine_enabled = 0
au BufNewFile,BufRead *.yaml,*.yml,*.j2 let g:indentLine_enabled = 1
nmap <F7> :IndentlinesToggle<Cr>

"" slime,
let g:slime_target = "neovim"
let g:slime_python_ipython = 1

" send visual selection, jump to end of the previous visual selection then move
" to the next nonblank line before the last line of the file
xmap <leader>s <Plug>SlimeRegionSend`>:call search('^.\+', '', line('$'))<Cr>
" send, jump to the end of paragraph then move to the next nonblank line
" before the last line file
nmap <leader>s <Plug>SlimeParagraphSend}:call search('^.\+', '', line('$'))<Cr>
nmap <leader>l <Plug>SlimeLineSend<Cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""


""" GENERAL
filetype plugin indent on
set scroll=15
set scrollback=100000
set signcolumn=auto
set hidden                          " easy to switch buffers/files with unsaved changes
set smartcase						" if pattern contains uppsecase, search is case-sensitve
" ignorecase while searching, use \C in the end to enforce case-sensitivity
" noignorecase in insert for autocompletion
set ignorecase
au InsertEnter * set noignorecase
au InsertLeave * set ignorecase
set lazyredraw                      " lazyredraw, for macro performance
set undodir=~/.config/nvim/undodir
"set undofile


""" NETRW
set wildignore+=.pyc,.git,venv,.ipynb_checkpoints,__pycache__ 	" used to hide files for vim-vinegar
" better preview, with file explorer to the left with 20% width
let g:netrw_preview = 1
let g:netrw_alto = 0
let g:netrw_winsize = 20
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'        " enable line number

" use p to preview
" toggle netrw
let g:NetrwIsOpen=0
au FileType netrw let g:NetrwIsOpen=1
function! ToggleNetrw()
    if g:NetrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
        silent Vexplore
    endif
endfunction
noremap <F2> :call ToggleNetrw()<CR>


""" EDITOR
set background=dark
set splitbelow splitright
set number relativenumber
set noshowmode                      " disable the redundant show mode on the last line
set list                            " used to enable listchars below
set listchars=tab:\ \ ,trail:•,extends:>,precedes:<
set nojoinspaces                    " no extra space after '.' when joining lines
set wildmode=longest,list,full      " better autocomplete in command mode
set diffopt=vertical				" git diff windows split to the side
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set expandtab
set fileformat=unix
set formatoptions-=tc               " disable auto wrap while typing
set completeopt=menu,noinsert		" autoselect the first entry in autocompletion


""" LEADERS
noremap <leader>y "+y
noremap <leader>p "+p
noremap <leader>q :q<Cr>
noremap <leader>w :w<Cr>
noremap <leader>cd :cd %:p:h<Cr>
noremap <leader>v <C-W><C-V>
noremap <leader>u :undo<Cr>


""" KEY MAPPINGS
map <Space> <leader>

noremap <C-J> <C-W><C-J>
noremap <C-K> <C-W><C-K>
noremap <C-L> <C-W><C-L>
noremap <C-H> <C-W><C-H>

noremap <C-Left> :vertical resize +5<Cr>
noremap <C-Right> :vertical resize -5<Cr>
noremap <C-Up> :resize +5<Cr>
noremap <C-Down> :resize -5<Cr>

" toggle search highlight
nmap <F3> :set hls!<Cr>
inoremap <F3> <C-O>:set hls!<Cr>
" hit '/' highlights then enter search mode
nnoremap / :set hls<Cr>/

" bring back the prev buffer, close the current one and keep the split panes
noremap <C-X> :bp\|bd #<Cr>

nnoremap S :%s///gc<Left><Left><Left><Left>
nnoremap Y y$
nnoremap Q @q
nnoremap H ^
nnoremap L $

" insert blank line, :set paste to disable auto indent
nnoremap <silent><A-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><A-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>

"" movements in insert mode
inoremap <C-D> <Del>

" tab for completion
inoremap <expr><TAB>  pumvisible() ? "\<C-y>" : "\<TAB>"

vnoremap > ^o^><Esc>gv
vnoremap < 0o0<<Esc>gv


""" CUSTOM COMMANDS
:command! Vs so ~/.config/nvim/init.vim
:command! Ve e ~/.config/nvim/init.vim


""" TERMINAL
tnoremap <Esc> <C-\><C-N>
tnoremap <C-J> <C-\><C-N><C-W><C-J>
tnoremap <C-K> <C-\><C-N><C-W><C-K>
tnoremap <C-L> <C-\><C-N><C-W><C-L>
tnoremap <C-H> <C-\><C-N><C-W><C-H>

nnoremap <leader>t :call ToggleTerm("default")<Cr>
function! ToggleTerm(termname)
	let pane = bufwinnr(a:termname)
	let buf = bufexists(a:termname)
	if pane > 0
		exe pane . "wincmd c"
	elseif buf > 0
		exe "split"
		exe "resize 15"
		exe "buffer " . a:termname
		exe "normal! i"
	else
		" if is a git repo, then use project root folder
		" else use original vim path
		try
			exe ":cd %:h | exe 'cd ' . fnameescape(get(systemlist('git rev-parse --show-toplevel'), 0))"
		catch
			echo "This is NOT a git repo"
		endtry
		exe "split"
		exe "resize 15"
		:terminal
		exe "f " a:termname
		exe "normal! i"
	endif
endfunction

""" remove trailing ws on save
function! TrimWhitespace()
  " trailing whitespaces have meaning in markdown so don't try there
  let blacklist = ['markdown', 'rst', 'md']
  if index(blacklist, &filetype) < 0
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
  endif
endfunction

autocmd BufWritePre * call TrimWhitespace()

""" Python autocommands
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=80 |
    \ set foldmethod=indent |
    \ set foldlevel=99 |

au BufNewFile,BufRead *.yaml,*.yml,*.j2
    \ set syntax=yaml |
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |

""" Web Dev autocommands
au BufNewFile,BufRead *.js,*.html,*.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |

