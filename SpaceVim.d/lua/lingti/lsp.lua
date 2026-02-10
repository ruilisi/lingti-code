local M = {}

-- Go to source definition for TypeScript/JavaScript
-- Uses typescript-language-server's _typescript.goToSourceDefinition command
-- which goes directly to the source file instead of stopping at imports
function M.go_to_source_definition()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local ts_client = nil

  -- Find typescript-language-server client
  for _, client in ipairs(clients) do
    if client.name == "ts_ls" or client.name == "tsserver" or client.name == "typescript-tools" then
      ts_client = client
      break
    end
  end

  if ts_client then
    -- Try TypeScript's source definition command
    local params = vim.lsp.util.make_position_params()
    ts_client.request("workspace/executeCommand", {
      command = "_typescript.goToSourceDefinition",
      arguments = { params.textDocument.uri, params.position },
    }, function(err, result)
      if err or not result or #result == 0 then
        -- Fallback to regular definition if source definition fails
        vim.lsp.buf.definition()
      else
        -- Jump to the first result
        local location = result[1]
        vim.lsp.util.jump_to_location(location, ts_client.offset_encoding)
      end
    end, 0)
  else
    -- Fallback to regular definition for non-TS files
    vim.lsp.buf.definition()
  end
end

return M
