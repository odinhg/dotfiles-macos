local map = function(mode, lhs, rhs, desc, opts)
  vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { silent = true, desc = desc }, opts or {}))
end

-- Move by screen line over wrapped prose, but keep counts (5j) linewise.
map("n", "j", "v:count == 0 ? 'gj' : 'j'", "Down", { expr = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", "Up", { expr = true })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", "Clear search highlight")

-- Search
local pick = function(name)
  return function() require("telescope.builtin")[name]() end
end
map("n", "<leader>ff", pick("find_files"), "Find files")
map("n", "<leader>fg", pick("live_grep"), "Live grep")
map("n", "<leader>fb", pick("buffers"), "Buffers")
map("n", "<leader>fh", pick("help_tags"), "Help tags")
map("n", "<leader>fd", pick("diagnostics"), "Diagnostics")
map("n", "<leader>fs", pick("lsp_document_symbols"), "Document symbols")
map("n", "<leader>fr", pick("resume"), "Resume last picker")

-- Tools
map("n", "<leader>n", "<cmd>Neotree toggle<CR>", "File tree")
map("n", "<leader>ft", "<cmd>ToggleTerm<CR>", "Terminal")
map("n", "<leader>lg", "<cmd>LazyGit<CR>", "LazyGit")

-- Buffers
for i = 1, 9 do
  map("n", "<leader>" .. i, "<cmd>BufferGoto " .. i .. "<CR>", "Buffer " .. i)
end
map("n", "<leader>0", "<cmd>BufferLast<CR>", "Last buffer")
map("n", "<leader><Right>", "<cmd>BufferNext<CR>", "Next buffer")
map("n", "<leader><Left>", "<cmd>BufferPrevious<CR>", "Previous buffer")
map("n", "<leader>bd", "<cmd>BufferClose<CR>", "Close buffer")

-- Writing
map("n", "<leader>tp", "<cmd>TypstPreviewToggle<CR>", "Typst preview")
map("n", "<leader>tg", function()
  local on = not vim.lsp.is_enabled("harper_ls")
  vim.lsp.enable("harper_ls", on)
  vim.notify("harper-ls " .. (on and "on" or "off"))
end, "Toggle grammar checking")
