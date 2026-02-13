function! lingti#before() abort
  " Add lua directory to runtime path for custom modules
  let &runtimepath = &runtimepath . ',' . expand('~/.SpaceVim.d')

  " Configure sourcekit-lsp with Xcode index store for Find References support
  autocmd User SpaceVimLspSetup lua require('lingti.lsp').setup_sourcekit()

  " Markdown Preview: disable auto-scroll, keep server alive
  let g:mkdp_refresh_slow = 0
  let g:mkdp_auto_close = 0
  let g:mkdp_preview_options = {
        \ 'disable_sync_scroll': 1,
        \ }

  " Auto-detect external file changes (e.g. from Claude Code edits)
  " Poll file mtime every 1s; force :edit to reload buffer and trigger mkdp refresh
  set autoread
  lua << EOF
  local last_mtime = {}
  local timer = vim.loop.new_timer()
  timer:start(2000, 2000, vim.schedule_wrap(function()
    local buf = vim.api.nvim_get_current_buf()
    if vim.bo[buf].filetype ~= 'markdown' then return end
    local fname = vim.api.nvim_buf_get_name(buf)
    if fname == '' then return end
    local stat = vim.loop.fs_stat(fname)
    if not stat then return end
    local mtime = stat.mtime.sec
    if last_mtime[fname] and last_mtime[fname] ~= mtime and not vim.bo[buf].modified then
      vim.cmd('silent! edit')
      pcall(vim.fn['mkdp#rpc#preview_refresh'])
    end
    last_mtime[fname] = mtime
  end))
EOF

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

function! s:ts_go_to_source_def() abort
  lua require('lingti.lsp').go_to_source_definition()
endfunction

function! s:lsp_go_to_def() abort
  " If a language-specific handler is registered, use it; otherwise LSP definition
  let l:handler = SpaceVim#mapping#gd#get()
  if !empty(l:handler)
    call call(l:handler, [])
  elseif luaeval('#vim.lsp.get_clients({bufnr = 0})') > 0
    lua vim.lsp.buf.definition()
  else
    normal! gd
  endif
endfunction

function! s:global_lsp_mappings() abort
  if luaeval('#vim.lsp.get_clients({bufnr = 0})') > 0
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>
    nnoremap <silent><buffer> gD :<C-u>call SpaceVim#lsp#go_to_typedef()<CR>
    nnoremap <silent><buffer> gr :lua vim.lsp.buf.references()<CR>
    nnoremap <silent><buffer> gi :lua vim.lsp.buf.implementation()<CR>
    nnoremap <silent><buffer> <leader>rn :lua vim.lsp.buf.rename()<CR>
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show-document', 1)
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

  " Global LSP keybindings: gd, gD, K, gr, gi, <leader>rn, SPC l ...
  " Applied to any buffer with an active LSP client.
  " TS uses go_to_source_definition for gd; all others use standard LSP definition.
  augroup global_lsp
    autocmd!
    autocmd LspAttach * call s:global_lsp_mappings()
  augroup END

  " gd: register per-filetype via SpaceVim's dispatcher
  " TypeScript: use source definition (skips re-exports/imports)
  call SpaceVim#mapping#gd#add('typescript', function('s:ts_go_to_source_def'))
  call SpaceVim#mapping#gd#add('typescriptreact', function('s:ts_go_to_source_def'))
  call SpaceVim#mapping#gd#add('javascript', function('s:ts_go_to_source_def'))
  call SpaceVim#mapping#gd#add('javascriptreact', function('s:ts_go_to_source_def'))

  " Override SpaceVim's gd to fall back to LSP instead of vim's native gd
  nnoremap <silent> gd :call <SID>lsp_go_to_def()<CR>
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
