local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
  callback = function() vim.hl.on_yank({ timeout = 300 }) end,
})

-- Reopen files at the last cursor position
autocmd("BufReadPost", {
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Diagnostics. Inline text only for warnings and errors, so harper's
-- grammar notes (info) stay in the sign column.
vim.diagnostic.config({
  severity_sort = true,
  virtual_text = { severity = { min = vim.diagnostic.severity.WARN } },
  float = { border = "rounded", source = true },
})

-- LSP keymaps. Neovim's default gr* maps are removed so `gr` fires instantly.
for _, lhs in ipairs({ "gra", "gri", "grn", "grr", "grt", "grx" }) do
  pcall(vim.keymap.del, "n", lhs)
end
pcall(vim.keymap.del, "v", "gra")

autocmd("LspAttach", {
  callback = function(ev)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
    end
    map("n", "gd", vim.lsp.buf.definition, "Definition")
    map("n", "gr", vim.lsp.buf.references, "References")
    map("n", "gR", vim.lsp.buf.rename, "Rename")
    map("n", "K", vim.lsp.buf.hover, "Hover")
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>ci", vim.lsp.buf.implementation, "Implementation")
    map("n", "<leader>cy", vim.lsp.buf.type_definition, "Type definition")
    map("n", "<leader>e", vim.diagnostic.open_float, "Diagnostic at cursor")
  end,
})

-- Prose: soft wrap at word boundaries. Spelling is done by harper-ls.
autocmd("FileType", {
  pattern = { "typst", "markdown", "tex", "text", "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.conceallevel = 2
  end,
})
