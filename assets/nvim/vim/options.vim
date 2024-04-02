set fillchars=fold:\ ,vert:\│,eob:\ ,msgsep:‾,diff:╱
set splitbelow splitright

set timeoutlen=500
set updatetime=500

set noswapfile

if !empty(provider#clipboard#Executable())
  set clipboard+=unnamedplus
endif

set wildignore+=*.o,*.obj,*.dylib,*.bin,*.dll,*.exe
set wildignore+=*/.git/*,*/.svn/*,*/__pycache__/*,*/build/**
set wildignore+=*.jpg,*.png,*.jpeg,*.bmp,*.gif,*.tiff,*.svg,*.ico
set wildignore+=*.pyc,*.pkl
set wildignore+=*.DS_Store
set wildignore+=*.aux,*.bbl,*.blg,*.brf,*.fls,*.fdb_latexmk,*.synctex.gz,*.xdv
set wildignorecase

let g:backupdir=expand(stdpath('data') . '/backup//')
let &backupdir=g:backupdir
let &backupskip=&wildignore
set backup
set backupcopy=yes

set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

set matchpairs+=<:>,「:」,『:』,【:】,“:”,‘:’,《:》

set number relativenumber

set ignorecase smartcase

set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

set linebreak
set showbreak=↪

set wildmode=list:longest

set scrolloff=3

set mouse=nic
set mousemodel=popup
set mousescroll=ver:1,hor:0

set noshowmode

set fileformats=unix

set confirm

set visualbell noerrorbells
set history=500

set list listchars=tab:▸\ ,extends:❯,precedes:❮,nbsp:␣

set autowrite

set undofile

set shortmess+=c
set shortmess+=S
set shortmess+=I

set completeopt+=menuone
set completeopt-=preview

set pumheight=10
set pumblend=10

set winblend=0

set complete+=kspell complete-=w complete-=b complete-=u complete-=t

set spelllang=en,pt
set spellsuggest+=9

set shiftround

set virtualedit=block

set formatoptions+=mM

set tildeop

set synmaxcol=250
set nostartofline

set termguicolors

set guicursor=n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor20

set signcolumn=yes:1

set isfname-==
set isfname-=,

set diffopt=
set diffopt+=vertical
set diffopt+=filler
set diffopt+=closeoff
set diffopt+=context:3
set diffopt+=internal,indent-heuristic,algorithm:histogram
set diffopt+=linematch:60

set nowrap
set noruler

if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
  set grepformat=%f:%l:%c:%m
endif
