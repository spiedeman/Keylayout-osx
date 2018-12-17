"keylayout.vim 记住插入模式的输入法状态
" Author：spiedeman
" Modified from：fcitx-osx.vim
" Require：keyboardSwitcher，installed by homebrew

" 加载一次
if exists('g:keylayout')
    finish
endif

set ttimeoutlen=10

if (has("win32") || has("win95") || has("win64") || has("win16"))
    " Windows 下不载入
    finish
endif

if exists('$SSH_TTY')
    finish
endif

if !executable("keyboardSwitcher")
    finish
endif
let s:save_cpo = &cpo
let g:loaded_keylaout = 1
set cpo&vim
" -------------------------------------------------------------------
"  Functions:
function Keylayout2en()
    let inputstatus = system('keyboardSwitcher get | cut -f2 -d\"')
    if inputstatus !~ 'ABC'
        let t = system('keyboardSwitcher select "ABC"')
        if !exists("b:last_status")
            let b:last_status = 0
        else
            let b:last_status = 1
        endif
    endif
endfunction

function Keylayout2zh()
    if exists("b:last_status") && b:last_status == 1
        let t = system('keyboardSwitcher select "Pinyin - Simplified"')
    endif
endfunction

" -------------------------------------------------------------------
"  Autocmds:
function BindKeylaout()
    augroup KeyLayout
        au InsertLeave * call Keylayout2en()
        au InsertEnter * call Keylayout2zh()
        au VimEnter * call Keylayout2en()
    augroup END
endfunction

function UnBindKeylayout()
    au! KeyLayout InsertLeave *
    au! KeyLayout InsertEnter *
endfunction

call BindKeylaout()

" -------------------------------------------------------------------
"  Restoration And Modelines:
let &cpo=s:save_cpo
unlet s:save_cpo

let g:keylayout = 1
