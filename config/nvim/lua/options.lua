local opt = vim.opt

-- Search
opt.hlsearch = false
opt.ignorecase = true
opt.smartcase = true

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.mouse = "a"
opt.breakindent = true
opt.scrolloff = 4
opt.splitbelow = true
opt.splitright = true
opt.background = "dark"

-- Behaviour
opt.undofile = true
opt.updatetime = 250
opt.timeoutlen = 400
opt.clipboard = "unnamedplus"
opt.confirm = true

-- Indentation (4 spaces, 2 for the filetypes below)
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "css", "html", "javascript", "json", "lua", "markdown", "nix", "toml", "typescript", "typst", "yaml" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})
