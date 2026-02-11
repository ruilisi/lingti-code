function! lingti#before() abort
  " Add lua directory to runtime path for custom modules
  let &runtimepath = &runtimepath . ',' . expand('~/.SpaceVim.d')

  " Enable devicons in LeaderF file list
  let g:Lf_ShowDevIcons = 1

  " typescript
  let g:neoformat_typescriptreact_prettier = {
        \ 'exe': 'prettier',
        \ 'args': ['--stdin', '--stdin-filepath', '"%:p"', '--parser', 'typescript'],
        \ 'stdin': 1
        \ }
  let g:neoformat_enabled_typescriptreact = ['prettier']
  let g:neoformat_enabled_ruby = ['rubocop']
endfunction

function! s:swift_lsp_mappings() abort
  if SpaceVim#layers#lsp#check_server('sourcekit')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>
    nnoremap <silent><buffer> gD :<C-u>call SpaceVim#lsp#go_to_typedef()<CR>
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show-document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'x'],
          \ 'call SpaceVim#lsp#references()', 'show-references', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename-symbol', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 's'],
          \ 'call SpaceVim#lsp#show_line_diagnostics()', 'show-line-diagnostics', 1)
  endif
endfunction

function! lingti#after() abort
  " Override SPC s P to use quickfix instead of FlyGrep
  " Note: Must use SpaceVim#mapping#space#def (immediate) not SpaceVim#custom#SPC (queued before bootstrap_after)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'P'], 'call SearchWordUnderCursorCount()', 'search word under cursor (quickfix)', 1)

  let g:ale_fixers = {
        \   'javascript': ['eslint', 'prettier'],
        \   'typescript': ['eslint', 'prettier'],
        \   'ruby': ['rubocop'],
        \}
  let g:ale_fix_on_save = 1

  " LSP keybindings for TypeScript/JavaScript (like Go)
  " gd         - go to source definition (skips imports)
  " gD         - go to definition (may stop at import)
  " K          - hover documentation
  " gr         - go to references
  " gi         - go to implementation
  " <leader>rn - rename symbol
  " LSP keybindings for Swift (like Go)
  if SpaceVim#layers#lsp#check_server('sourcekit')
    call SpaceVim#mapping#gd#add('swift',
          \ function('SpaceVim#lsp#go_to_def'))
  endif
  augroup swift_lsp
    autocmd!
    autocmd FileType swift call s:swift_lsp_mappings()
  augroup END

  augroup typescript_lsp
    autocmd!
    autocmd FileType typescript,typescriptreact,javascript,javascriptreact
          \ nnoremap <buffer> <silent> gd :lua require('lingti.lsp').go_to_source_definition()<CR>|
          \ nnoremap <buffer> <silent> gD :lua vim.lsp.buf.definition()<CR>|
          \ nnoremap <buffer> <silent> K :lua vim.lsp.buf.hover()<CR>|
          \ nnoremap <buffer> <silent> gr :lua vim.lsp.buf.references()<CR>|
          \ nnoremap <buffer> <silent> gi :lua vim.lsp.buf.implementation()<CR>|
          \ nnoremap <buffer> <silent> <leader>rn :lua vim.lsp.buf.rename()<CR>
  augroup END
  let g:ctrlp_max_files=0
  let g:neoformat_enabled_javascript = ['eslint', 'prettier']
  let g:neoformat_enabled_javascriptreact = ['eslint', 'prettier']
  let g:neoformat_enabled_typescript = ['eslint', 'prettier']
  let g:neoformat_enabled_typescriptreact = ['eslint', 'prettier']
  call SpaceVim#layers#core#tabline#get()
endfunction

" load customized settings

let vimsettings = '~/.lingti/SpaceVim.d/autoload/settings'
let uname = system("uname -s")

for fpath in split(globpath(vimsettings, '*.vim'), '\n')
  if (fpath == expand(vimsettings) . "/lingti-keymap-mac.vim") && uname[:4] ==? "linux"
    continue " skip mac mappings for linux
  endif

  if (fpath == expand(vimsettings) . "/lingti-keymap-linux.vim") && uname[:4] !=? "linux"
    continue " skip linux mappings for mac
  endif

  exe 'source' fpath
endfor
let g:smoothie_enabled = 0
let ruby_no_expensive=1
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true
