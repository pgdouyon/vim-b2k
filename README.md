B2K
===

B2K provides CamelCase, snake_case, and kebab-case motions for Vim.  By default
they're mapped to the w,b,e,ge keys, but can be remapped using `<Plug>B2K_*`
where '\*' is w, b, e, or ge.

B2K also provides an 'iw' text object for visual and operator-pending modes.
It's mapped to iw by default but can be remapped using `<Plug>B2K_iw`

To turn off default mappings copy the following line into your vimrc:
`let g:b2k_no_mappings = 1`


Installation
------------

* [Pathogen][]
    * `cd ~/.vim/bundle && git clone https://github.com/pgdouyon/vim-b2k.git`
* [Vundle][]
    * `Plugin 'pgdouyon/vim-b2k'`
* [NeoBundle][]
    * `NeoBundle 'pgdouyon/vim-b2k'`
* [Vim-Plug][]
    * `Plug 'pgdouyon/vim-b2k'`
* Manual Install
    * Copy all the files into the appropriate directory under `~/.vim` on \*nix or
      `$HOME/_vimfiles` on Windows


License
-------

Copyright (c) 2014 Pierre-Guy Douyon.  Distributed under the MIT License.


[Pathogen]: https://github.com/tpope/vim-pathogen
[Vundle]: https://github.com/gmarik/Vundle.vim
[NeoBundle]: https://github.com/Shougo/neobundle.vim
[Vim-Plug]: https://github.com/junegunn/vim-plug
