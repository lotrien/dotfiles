"
" Author: Ihor Kalnytskyi <ihor@kalnytskyi.com>
" Source: https://raw.githubusercontent.com/ikalnytskyi/dotfiles/master/nvim/.config/nvim/init.vim
"

scriptencoding utf-8

" VIMHOME should point to ~/.config/nvim directory and is used as a general
" way to retrieve a path to NeoVim goodies.
let $VIMHOME=fnamemodify($MYVIMRC, ':h')

"
" // BOOTSTRAP //
"

if !filereadable($VIMHOME . '/autoload/plug.vim')
  if executable('curl')
    silent! !curl -fLo $VIMHOME/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * silent! PlugInstall --sync | source $MYVIMRC
  endif
endif

if !filereadable($VIMHOME . '/tmp/runtime/py3/bin/python')
  try
    if executable('virtualenv')
      !virtualenv -ppython3 $VIMHOME/tmp/runtime/py3
    elseif executable('python3')
      !python3 -m venv $VIMHOME/tmp/runtime/py3
    endif
  finally
    !$VIMHOME/tmp/runtime/py3/bin/pip install pynvim
  endtry
endif
let g:python3_host_prog = $VIMHOME . '/tmp/runtime/py3/bin/python'

try
  python3 import pynvim
catch
  echomsg "please ensure 'pynvim' is installed in your python environment"
endtry

"
" // PLUGINS //
"

silent! if plug#begin($VIMHOME . '/plugins')
  Plug 'preservim/nerdtree'
  Plug 'liuchengxu/vista.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'mhinz/vim-signify'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'mg979/vim-visual-multi'
  Plug 'Valloric/ListToggle'
  Plug 'godlygeek/tabular'
  Plug 'arcticicestudio/nord-vim', { 'branch': 'develop' }
  Plug 'tpope/vim-sleuth'
  Plug 'liuchengxu/vim-clap', { 'do': { -> clap#installer#force_download() } }
  Plug 'vim-test/vim-test'

  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'ncm2/ncm2'
  Plug 'roxma/nvim-yarp'
  Plug 'ncm2/ncm2-vim-lsp'
  Plug 'ncm2/ncm2-bufword'
  Plug 'ncm2/float-preview.nvim'

  Plug 'cespare/vim-toml', {'for': ['toml']}
  Plug 'iloginow/vim-stylus', {'for': ['stylus']}
  Plug 'leafgarland/typescript-vim', {'for': ['typescript']}
  Plug 'octol/vim-cpp-enhanced-highlight', {'for': ['cpp']}
  Plug 'pangloss/vim-javascript', {'for': ['javascript']}
  Plug 'plasticboy/vim-markdown', {'for': ['markdown']}
  Plug 'Glench/Vim-Jinja2-Syntax', {'for': ['jinja']}
  Plug 'dag/vim-fish', {'for': ['fish']}
  Plug 'norcalli/nvim-colorizer.lua'
  Plug 'ryanoasis/vim-devicons'
  Plug 'chrisbra/unicode.vim'

  Plug '~/devel/vim-sway'

  call plug#end()

  " ~ liuchengxu/vim-clap

  let g:clap_insert_mode_only = v:true
  let g:clap_selected_sign = {
    \ "text": "ᐅ",
    \ "texthl": "ClapSelectedSign",
    \ "linehl": "ClapSelected"
  \ }
  let g:clap_current_selection_sign = {
    \ "text": "ᐉ",
    \ "texthl": "ClapCurrentSelectionSign",
    \ "linehl": "ClapCurrentSelection"
  \ }
  let g:clap_prompt_format = '%spinner%%forerunner_status%%provider_id%: '

  " ~ ncm2/float-preview.nvim

  let g:float_preview#docked = 0

  " ~ ncm2/ncm2

  augroup NCM2
    autocmd!
    autocmd BufEnter * silent! call ncm2#enable_for_buffer()
    autocmd User Ncm2Plugin call ncm2#register_source({
      \ 'name' : 'css',
      \ 'priority': 8,
      \ 'subscope_enable': 1,
      \ 'scope': ['css', 'scss', 'less', 'stylus'],
      \ 'mark': 'css',
      \ 'word_pattern': '[\w\-]+',
      \ 'complete_pattern': ':\s*',
      \ 'on_complete': ['ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
    \ })
  augroup END

  " ~ prabirshrestha/vim-lsp

  let g:lsp_signs_enabled = 0
  let g:lsp_virtual_text_enabled = 0
  let g:lsp_diagnostics_float_cursor = 1
  let g:lsp_highlight_references_enabled = 1

  augroup LSP
    autocmd!

    if executable('pyls')
      autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'allowlist': ['python'],
        \ 'priority': 1,
        \ 'workspace_config': {
          \ 'pyls': {
            \ 'plugins': {
              \ 'flake8': {'enabled': v:true, 'maxLineLength': 100},
              \ 'pycodestyle': {'enabled': v:false},
            \ },
          \ },
        \ },
      \ })
      autocmd FileType python setlocal omnifunc=lsp#complete
    endif

    if executable('clangd')
      autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd']},
        \ 'allowlist': ['c', 'cpp', 'objc'],
        \ 'priority': 1,
      \ })
      autocmd FileType c,cpp setlocal omnifunc=lsp#complete

      let g:vista_c_executive = "vim_lsp"
      let g:vista_cpp_executive = "vim_lsp"
    endif

    if executable('rust-analyzer')
      autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'rust-analyzer',
        \ 'cmd': {server_info->['rust-analyzer']},
        \ 'allowlist': ['rust'],
        \ 'priority': 1,
      \ })
      autocmd FileType rust setlocal omnifunc=lsp#complete

      let g:vista_rust_executive = "vim_lsp"
    elseif executable('rls')
      autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rls']},
        \ 'allowlist': ['rust'],
        \ 'priority': 1,
      \ })
      autocmd FileType rust setlocal omnifunc=lsp#complete

      let g:vista_rust_executive = "vim_lsp"
    endif

    if executable('bash-language-server')
      autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'bash-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
        \ 'allowlist': ['sh'],
        \ 'priority': 1,
      \ })
      autocmd FileType sh setlocal omnifunc=lsp#complete

      let g:vista_sh_executive = "vim_lsp"
    endif

    if executable('javascript-typescript-stdio')
      autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'jls',
        \ 'cmd': {server_info->['javascript-typescript-stdio']},
        \ 'allowlist': ['javascript', 'typescript'],
        \ 'priority': 1,
      \ })
      autocmd FileType javascript,typescript setlocal omnifunc=lsp#complete

      let g:vista_javascript_executive = "vim_lsp"
      let g:vista_typescript_executive = "vim_lsp"
    endif

    if executable('gopls')
      autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls']},
        \ 'allowlist': ['go'],
        \ 'priority': 1,
      \ })
      autocmd FileType go setlocal omnifunc=lsp#complete
    endif
  augroup END

  " ~ scrooloose/nerdtree

  let g:NERDTreeQuitOnOpen = 1
  let g:NERDTreeShowHidden = 1
  let g:NERDTreeMinimalUI = 1

  function! s:MyNERDTreeToggleVCS()
    let s:path = expand('%:p')

    execute ':NERDTreeToggleVCS'

    " Find and show currently open file in the file explorer. It's the primary
    " reason why this home grown function exists in the first place.
    if exists('g:NERDTree') && g:NERDTree.IsOpen() && filereadable(s:path)
      execute ':NERDTreeFind' . s:path
    endif
  endfunction

  command! -n=? -complete=dir -bar MyNERDTreeToggleVCS :call <SID>MyNERDTreeToggleVCS()

  " ~ liuchengxu/vista.vim

  let g:vista_echo_cursor = 0
  let g:vista_sidebar_width = 30
  let g:vista_close_on_jump = 1
  let g:vista_icon_indent = ["▸ ", ""]
  let g:vista_blink = [0, 0]
  let g:vista_echo_cursor = 1
  let g:vista_echo_cursor_strategy = "floating_win"

  " ~ Valloric/ListToggle

  let g:lt_location_list_toggle_map = '<leader>l'
  let g:lt_quickfix_list_toggle_map = '<leader>q'

  " ~ vim-test/vim-test

  let test#python#pytest#options = '-vv'

  " ~ arcticicestudio/nord-vim

  let g:nord_bold_vertical_split_line = 1
  let g:nord_cursor_line_number_background = 1

  augroup NORD
    autocmd!

    function! MyNordEnhancements()
      " Emphasize identifiers in the code.
      exe 'hi! Identifier gui=bold'
    endfunction

    " Activate colorscheme later on because it may depend on some other
    " settings such as 'termguicolors' which we enable in 'general' section
    " below.
    autocmd User late_settings silent! colorscheme nord | call MyNordEnhancements()
    autocmd ColorScheme nord call MyNordEnhancements()
  augroup END

  " ~ pangloss/vim-javascript

  let g:javascript_plugin_jsdoc = 1
  let g:javascript_plugin_flow = 1

  " ~ plasticboy/vim-markdown

  let g:vim_markdown_frontmatter = 1
  let g:vim_markdown_conceal = 0
  let g:vim_markdown_auto_insert_bullets = 0
  let g:vim_markdown_new_list_item_indent = 0

  " ~ vim-test/vim-test

  let test#python#pytest#options = '-vv'

  " ~ norcalli/nvim-colorizer.lua

  augroup COLORIZER
    autocmd!

    " colorizer.setup() depends on 'termguicolors' being set and thus we need
    " to postpone its call till the later stage.
    autocmd User late_settings silent! lua require 'colorizer'.setup({
      \ css = { css = true };
      \ stylus = { css = true };
      \ javascript;
      \ html;
    \ })
  augroup END

endif

"
" // GENERAL //
"

if $COLORTERM == 'truecolor' || $COLORTERM == '24bit'
  set termguicolors
endif

set autochdir                       " change cwd to current file
set colorcolumn=80,100              " show columns at 80 & 100 characters
set completeopt=menuone             " show menu even for a single match
set completeopt+=noinsert,noselect  " do not auto- select/insert completions
set cursorline                      " highlight the line with cursor
set expandtab                       " insert space instead the tab
set formatoptions+=r                " auto insert comment leader on <enter>
set hidden                          " do not abandon buffers, hid them instead
set ignorecase                      " case insensitive search
set lazyredraw                      " do not redraw screen on macros execution, etc
set list                            " show unprintable characters
set listchars=tab:»·,trail:·        " set unprintable characters
set mouse=a                         " enable mouse support in all Vim modes
set mousehide                       " hide mouse cursor when typing
set nofoldenable                    " no code folding, I hate it
set noshowmode                      " do not show Vim mode, airline shows it
set noswapfile                      " do not create swap files
set notimeout                       " no timeout on keybindings (aka mappings)
set nowrap                          " do not wrap lines visually
set number                          " show line numbers
set scrolloff=3                     " start scrolling 3 lines ahead
set shiftwidth=4                    " shift lines by 4 spaces
set shortmess+=c                    " supress 'match X of Y' message
set showbreak=↪                     " character to mark wrapped line
set sidescrolloff=3                 " start scrolling 3 columns ahead
set smartcase                       " match uppercase in the search string
set softtabstop=4                   " insert spaces instead of tabs
set spelllang=en,ru                 " languages to spellcheck
set tabstop=8                       " set tab width
set title                           " propagate useful info to window title
set ttimeout                        " do timeout on key codes
set undofile                        " persistent undo (survives Vim restart)
set visualbell                      " flash screen instead of beep

"
" // KEYBINDINGS //
"

nnoremap <leader>1 :MyNERDTreeToggleVCS<CR>
nnoremap <leader>2 :Vista!!<CR>
nnoremap <leader>3 :set spell!<CR>
nnoremap <leader>4 :SignatureListBufferMarks<CR>
nnoremap <C-P> :Clap gfiles<CR>
nnoremap <leader>g :Clap grep<CR>
nnoremap <leader>d :LspDefinition<CR>
nnoremap <leader><S-d> :LspPeekDefinition<CR>
nnoremap <leader>h :LspHover<CR>
nnoremap <leader>r :LspReferences<CR>
nnoremap <leader>i :LspDocumentDiagnostics<CR>
nnoremap <leader>s :LspDocumentSymbol<CR>
nnoremap <leader>w :LspWorkspaceSymbols<CR>
nnoremap <leader><S-f> :LspDocumentFormat<CR>
vnoremap <leader><S-f> :LspDocumentRangeFormat<CR>
nnoremap <leader>t :TestNearest<CR>

function! OnEnterPressed()
  return empty(v:completed_item) ? "\<C-y>\<CR>" : "\<C-y>"
endfunction

inoremap <expr> <CR> pumvisible() ? OnEnterPressed() : "\<CR>"
inoremap <expr> <Esc> pumvisible() ? "\<C-e>\<Esc>" : "\<Esc>"
inoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up> pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp> pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

noremap <Leader>y "+y
noremap <Leader>p "+p
noremap <Leader>Y "*y
noremap <Leader>P "*p

"
" // LANGUAGES //
"

augroup FILETYPES
  autocmd!
  autocmd BufReadPost .babelrc setlocal filetype=json
  autocmd BufReadPost .eslintrc setlocal filetype=json
augroup END

augroup PYTHON
  autocmd!
  autocmd FileType python setlocal comments+=b:#:   " sphinx (#:) comments
augroup END

"
" // LATE SETTINGS //
"

doautocmd User late_settings
