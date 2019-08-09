" Prevent double-sourcing  -----------------------------------------------------
execute exists('g:loaded_barbaric') ? 'finish' : 'let g:loaded_barbaric = 1'

" off / on ---------------------------------------------------------------------
function! barbaric#off()
  call s:set_im(g:barbaric_default)
  call s:record_im()
endfunction

function! barbaric#on(im)
  call s:set_im(a:im)
  call barbaric#switch('focus')
endfunction

" switch mode ------------------------------------------------------------------
function! barbaric#switch(next_mode)
  let l:m = mode()
  let l:next_mode = a:next_mode
  if l:next_mode == 'focus'
    call s:record_im()
    if l:m == 'i'
      let l:next_mode = 'insert'
    else
      let l:next_mode = 'normal'
    endif
  elseif l:next_mode == 'unfocus'
    let l:next_mode = 'insert'
  endif
  if l:next_mode == 'normal'
    call s:set_im(g:barbaric_default)
  elseif l:next_mode == 'insert'
    if !exists('g:barbaric_current') | return | endif
    call s:set_im(g:barbaric_current)
  endif
endfunction

" Input method -----------------------------------------------------------------
function! s:record_im()
  if g:barbaric_ime == 'macos'
    let l:im = system('xkbswitch -g')
  elseif g:barbaric_ime == 'fcitx'
    let l:im = system('fcitx-remote') == 2 ? '-o' : '-c'
  elseif g:barbaric_ime == 'ibus'
    let l:im = system('ibus engine')
  endif
  if l:im == g:barbaric_default
    execute 'silent! unlet g:barbaric_current'
  else
    execute "silent! let g:barbaric_current = '" . l:im . "'"
  endif
endfunction

function! s:set_im(im)
  if g:barbaric_ime == 'macos'
    silent call system('xkbswitch -s ' . a:im)
  elseif g:barbaric_ime == 'fcitx'
    silent call system('fcitx-remote ' . a:im)
  elseif g:barbaric_ime == 'ibus'
    silent call system('ibus engine ' . a:im)
  endif
endfunction
