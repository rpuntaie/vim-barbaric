if !has('gui_running')
  finish
endif

" Check dependencies
if has('mac') && executable('xkbswitch')
  let g:barbaric_ime = 'macos'
elseif executable('fcitx-remote') && system('fcitx-remote') > 0
  let g:barbaric_ime = 'fcitx'
elseif executable('ibus')
  let g:barbaric_ime = 'ibus'
else
  finish
endif

" The input method for Normal mode (as defined by `xkbswitch -g` or `ibus engine`)
if !exists('g:barbaric_default')
  if g:barbaric_ime == 'fcitx'
    let g:barbaric_default = '-c'
  else
    let g:barbaric_default = barbaric#get_im()
  endif
endif

augroup barbaric
  autocmd!
  autocmd InsertEnter * call barbaric#switch('insert')
  autocmd InsertLeave * call barbaric#switch('normal')
  autocmd FocusGained * call barbaric#switch('focus')
  autocmd FocusLost   * call barbaric#switch('unfocus')
  autocmd VimLeave    * call barbaric#switch('unfocus')
augroup END
