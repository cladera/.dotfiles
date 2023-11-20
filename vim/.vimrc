syntax on

set nu
set relativenumber

inoremap jk <Esc>
inoremap kj <Esc>

if has('nvim') && executable('nvr')
  let $GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
endif
