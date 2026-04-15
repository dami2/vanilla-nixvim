-- [!TIP]
-- The variables `client` and `bufnr` are made available in scope.
-- local client = client
-- local bufnr = bufnr
-- local vim = vim

-- NOTE: Remember that Lua is a real programming language, and as such it is possible
-- to define small helper and utility functions so you don't have to repeat yourself.
--
-- In this case, we create a function that lets us more easily define mappings specific
-- for LSP related items. It sets the mode, buffer and description for us each time.
local map = function(keys, func, desc, mode)
  mode = mode or "n"
  vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
end

-- The following two autocommands are used to highlight references of the
-- word under your cursor when your cursor rests there for a little while.
--    See `:help CursorHold` for information about when this is executed
--
-- When you move your cursor, the highlights will be cleared (the second autocommand).
if client:supports_method("textDocument/documentHighlight", bufnr) then
  local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    buffer = bufnr,
    group = highlight_augroup,
    callback = vim.lsp.buf.document_highlight,
  })

  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    buffer = bufnr,
    group = highlight_augroup,
    callback = vim.lsp.buf.clear_references,
  })

  vim.api.nvim_create_autocmd("LspDetach", {
    group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
    callback = function(event2)
      vim.lsp.buf.clear_references()
      vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
    end,
  })
end

-- The following code creates a keymap to toggle inlay hints in your
-- code, if the language server you are using supports them
--
-- This may be unwanted, since they displace some of your code
if client:supports_method("textDocument/inlayHint", bufnr) then
  map("<leader>th", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
  end, "[T]oggle Inlay [H]ints")
end

if client:supports_method("textDocument/completion", bufnr) then
  vim.opt.completeopt = { "menu", "menuone", "noinsert", "popup" }
  vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
  vim.keymap.set("i", "<C-Space>", function()
    vim.lsp.completion.get()
  end)
end
