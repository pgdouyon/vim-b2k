"==============================================================================
"File:        b2k.vim
"Description: Camel-case motions and iw text object
"Maintainer:  Pierre-Guy Douyon <pgdouyon@alum.mit.edu>
"Version:     1.0.0
"Last Change: 2014-08-05
"License:     MIT <../LICENSE>
"==============================================================================

if exists("g:loaded_b2k")
    finish
endif
let g:loaded_b2k = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

function! s:isUnitWidthSep(char)
    let word_char = '\%(\w\&[^-_]\)'
    let symbol = '\%(\W\&\S\&[^-_]\)'
    let unit_width_sep = '\s\|[-_]'
    let unit_width_sep .= '\|' . word_char . '\zs' . symbol . '\ze' . word_char
    let is_unit_width_sep = (a:char =~ unit_width_sep)
    return is_unit_width_sep
endfunction


function! s:NextNonKeyword(forward, cursor_match)
    let word_char = '\%(\w\&[^-_]\)'
    let non_uppercase = '\%(\l\|\d\)'
    let symbol = '\%(\W\&\S\&[^-_]\)'

    let zero_width_sep = non_uppercase . '\zs\u\ze' . non_uppercase
    let zero_width_sep .= '\|\u\zs\u\ze' . non_uppercase
    let zero_width_sep .= '\|' . symbol . '\@<!\zs' . symbol . '\ze' . symbol
    let zero_width_sep .= '\|' . symbol . symbol . '\zs' . symbol . '\@!'
    let zero_width_sep .= '\|^'

    let unit_width_sep = '\s'
    let unit_width_sep .= '\|[-_]'
    let unit_width_sep .= '\|' . word_char . '\zs' . symbol . '\ze' . word_char

    let nonkeyword = zero_width_sep . '\|' . unit_width_sep
    let flags = 'W'
    let flags .= a:forward ? '' : 'b'
    let flags .= a:cursor_match ? 'c' : ''
    call search(nonkeyword, flags)
endfunction


function! s:NextKeyword(forward, cursor_match)
    let word_char = '\%(\w\&[^-_]\)'
    let non_uppercase = '\%(\l\|\d\)'
    let symbol = '\%(\W\&\S\&[^-_]\)'
    let whitespace = '\%(\s\|[-_]\)'

    let zero_width_sep = non_uppercase . '\zs\u\ze' . non_uppercase
    let zero_width_sep .= '\|\u\zs\u\ze' . non_uppercase
    let zero_width_sep .= '\|' . word_char . '\zs' . symbol . '\ze' . symbol
    let zero_width_sep .= '\|' . symbol . symbol . '\zs' . word_char
    let zero_width_sep .= '\|\s\zs' . symbol . '\ze' . symbol
    let zero_width_sep .= '\|' . symbol . '\zs' . symbol . '\ze\s'

    let keyword = '\w\&[^-_]' . '\|' . zero_width_sep
    let keyword .= '\|' . whitespace . '\zs' . symbol . '\ze' . whitespace
    let flags = 'W'
    let flags .= a:forward ? '' : 'b'
    let flags .= a:cursor_match ? 'c' : ''
    call search(keyword, flags)
endfunction


function! s:B2KForwardMotion(forward, mode)
    if (a:mode ==? "v")
        normal! gv
    elseif (a:mode ==? "o")
        normal! v
    endif

    let char_under_cursor = getline(".")[col(".") - 1]
    let nonword_cursor_match = (s:isUnitWidthSep(char_under_cursor) || !a:forward)
    let word_cursor_match = a:forward
    call s:NextNonKeyword(a:forward, nonword_cursor_match)
    call s:NextKeyword(a:forward, word_cursor_match)

    if (a:mode ==? "o") && a:forward
        call search(".", "bW")
    endif
endfunction


function! s:B2KBacktrackMotion(forward, mode)
    if (a:mode ==? "v")
        normal! gv
    elseif (a:mode ==? "o")
        execute (!a:forward ? 'call search(".", "bW")|' : '')."normal! v"
    endif

    let backtrack = !a:forward
    let cursor_match = !a:forward
    call s:NextKeyword(a:forward, 0)
    call s:NextNonKeyword(a:forward, cursor_match)
    call s:NextKeyword(backtrack, cursor_match)
endfunction


function! s:B2KInnerWord(mode)
    let char_under_cursor = getline(".")[col(".") - 1]
    if s:isUnitWidthSep(char_under_cursor)
        return
    endif
    call search(".", "W")
    execute "normal \<Plug>B2K_b"
    execute "normal! \<Esc>v"
    execute "normal \<Plug>B2K_e"
endfunction

nnoremap <silent> <Plug>B2K_w :<C-u>call <SID>B2KForwardMotion(1, "n")<CR>
nnoremap <silent> <Plug>B2K_b :<C-u>call <SID>B2KBacktrackMotion(0, "n")<CR>
nnoremap <silent> <Plug>B2K_e :<C-u>call <SID>B2KBacktrackMotion(1, "n")<CR>
nnoremap <silent> <Plug>B2K_ge :<C-u>call <SID>B2KForwardMotion(0, "n")<CR>

xnoremap <silent> <Plug>B2K_w :<C-u>call <SID>B2KForwardMotion(1, "v")<CR>
xnoremap <silent> <Plug>B2K_b :<C-u>call <SID>B2KBacktrackMotion(0, "v")<CR>
xnoremap <silent> <Plug>B2K_e :<C-u>call <SID>B2KBacktrackMotion(1, "v")<CR>
xnoremap <silent> <Plug>B2K_ge :<C-u>call <SID>B2KForwardMotion(0, "v")<CR>
xnoremap <silent> <Plug>B2K_iw :<C-u>call <SID>B2KInnerWord("v")<CR>

onoremap <silent> <Plug>B2K_w :<C-u>call <SID>B2KForwardMotion(1, "o")<CR>
onoremap <silent> <Plug>B2K_b :<C-u>call <SID>B2KBacktrackMotion(0, "o")<CR>
onoremap <silent> <Plug>B2K_e :<C-u>call <SID>B2KBacktrackMotion(1, "o")<CR>
onoremap <silent> <Plug>B2K_ge :<C-u>call <SID>B2KForwardMotion(0, "o")<CR>
onoremap <silent> <Plug>B2K_iw :<C-u>call <SID>B2KInnerWord("v")<CR>

if !exists("g:b2k_no_mappings") || (g:b2k_no_mappings == 0)
    map w <Plug>B2K_w
    map b <Plug>B2K_b
    map e <Plug>B2K_e
    map ge <Plug>B2K_ge
    xmap iw <Plug>B2K_iw
    omap iw <Plug>B2K_iw
endif

let &cpoptions = s:save_cpo
unlet s:save_cpo
