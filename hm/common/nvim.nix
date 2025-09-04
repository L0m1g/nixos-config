{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    withNodeJs = true;
    withPython3 = true;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    coc.enable = true;

    plugins = with pkgs.vimPlugins; [
      goyo-vim
      nerdtree
      limelight-vim
    ];

    extraConfig = ''
      set number
      set relativenumber
      set scrolloff=4
      set signcolumn=yes

      set mouse=a
      set clipboard=unnamedplus

      set ignorecase
      set smartcase
      set incsearch

      set tabstop=2
      set shiftwidth=2
      set expandtab

      set splitright
      set splitbelow
      set termguicolors
      set updatetime=300

      set undofile

      let mapleader = " "

      colorscheme retrobox
      syntax enable

      nnoremap <F10> :Goyo<CR>
      inoremap <F10> <Esc> :Goyo<CR>

      let g:goyo_width = 100

      command! Q qall!

      " --- Fichiers d’état : swap / backup / undo ---
      let s:state = has('unix') ? $HOME . '/.local/state/nvim' : $HOME . '/nvim-state'

      " Crée les dossiers si besoin (silencieusement)
      silent! call mkdir(s:state . '/swap', 'p')
      silent! call mkdir(s:state . '/backup', 'p')
      silent! call mkdir(s:state . '/undo', 'p')

      augroup MdNoSuggest
        autocmd!
        autocmd FileType markdown let b:coc_suggest_disable = 1 | let b:coc_diagnostic_disable = 1
      augroup END

      " Goyo : pas de coupure de mots + Limelight auto
      autocmd User GoyoEnter
            \ let w:_wrap=&l:wrap | let w:_tw=&l:textwidth | let w:_fo=&l:formatoptions |
            \ setlocal wrap linebreak nolist textwidth=0 |
            \ setlocal formatoptions-=t formatoptions-=c formatoptions-=r formatoptions-=o formatoptions-=l |
            \ Limelight

      autocmd User GoyoLeave
            \ if exists('w:_wrap') | let &l:wrap=w:_wrap | unlet w:_wrap | endif |
            \ if exists('w:_tw')   | let &l:textwidth=w:_tw | unlet w:_tw | endif |
            \ if exists('w:_fo')   | let &l:formatoptions=w:_fo | unlet w:_fo | endif |
            \ Limelight!

      " Swap files (fichiers d’échange)
      set directory^=~/.local/state/nvim/swap//

      " Backups (copie avant écriture) – optionnel mais utile
      set backup
      set writebackup
      set backupdir=~/.local/state/nvim/backup//

      " Undo persistant (♥ pour la rédaction)
      set undofile
      set undodir=~/.local/state/nvim/undo//

      " --- Résolution auto des conflits de swap ---
      augroup ResolveSwap
        autocmd!
        " Si un swap existe quand on ouvre un fichier…
        autocmd SwapExists * call s:ResolveSwap(v:swapname, expand('<afile>'))
      augroup END

      function! s:ResolveSwap(swapname, filename) abort
        " Si le fichier sur disque est plus récent que le swap -> on édite quand même (e)
        if getftime(a:filename) > getftime(a:swapname)
          let v:swapchoice = 'e'   " edit anyway (ignore le swap)
        else
          " Sinon, ouvre en lecture seule par prudence (o).
          " Tu pourras décider ensuite (écraser, récupérer, diff).
          let v:swapchoice = 'o'
        endif
      endfunction

      " Rendre les messages de swap moins dramatiques
      set shortmess+=A
    '';

    extraPackages = with pkgs; [
      ripgrep
      fd
      xclip
    ];
  };
}
# vim: set ts=2 sw=2 sts=2 et :

