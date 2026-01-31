# Frequently Asked Questions
## `vim-import-js building failed` when run `SPUpdate`
When `SPUpdate` updates `vim-import-js`, it will try run `npm install -g import-js` and related directory permissions should be ensured to make this step pass.

## `SpaceVim Unknown function: TSOnBufEnter`
* References
  * https://github.com/SpaceVim/SpaceVim/issues/1800
  * https://github.com/SpaceVim/SpaceVim/issues/3221
* Resolution steps
  * Delete cache   rm -rf ~/.cache/vimfiles/.cache
  * Open vim  run `:CheckHealth` check the current vim status, and fix any errors.
  * Install pip for `python3` if not: `curl https://bootstrap.pypa.io/get-pip.py | python3`
  * `pip install neovim`
  * `npm install -g neovim typescript`
  * Run `:UpdateRemotePlugins` in vim and reopen vim

## `nvim-typescript` is not installed successfully when run `:SPUpdate`
* Add `call dein#reinstall(['nvim-typescript'])` to `~/.local/share/nvim/rplugin.vim`, reopen vim and wait for the `nvim-typescript` plugin to install
* Install it manually:
  ```bash
  cd ~/.cache/vimfiles/repos/github.com/mhartington/
  rm -rf nvim-typescript
  git clone https://github.com/mhartington/nvim-typescript
  cd nvim-typescript
  npm config set registry=https://registry.npmjs.com/
  ./install.sh
  ```

## `TSCloseWindow` error: "Channel doesn't exist" on CursorMoved in TypeScript files
```
Error detected while processing CursorMoved Autocommands for "*.ts"..function TSCloseWindow[1]..remote#define#notify:
line    6:
E475: Invalid argument: Channel doesn't exist
```
This error indicates a Neovim remote plugin (likely related to TypeScript tooling) has lost its RPC channel connection. The `TSCloseWindow` function is trying to communicate with a plugin that has crashed or wasn't properly initialized.

* Resolution steps
  1. Add `tsserver` to LSP enabled clients in `SpaceVim.d/init.toml`:
     ```toml
     [[layers]]
     name = "lsp"
     enabled_clients = ['pyright', "gopls", "tsserver"]
     ```
  2. Install TypeScript language server globally:
     ```bash
     npm install -g typescript typescript-language-server
     ```
  3. Regenerate remote plugins - run `:UpdateRemotePlugins` in Neovim, then restart
  4. If the above doesn't work, clear the remote plugin cache:
     ```bash
     rm -rf ~/.local/share/nvim/rplugin.vim
     ```
     Then reopen Neovim and run `:UpdateRemotePlugins` again
