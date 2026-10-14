-- Leader keys must be set before lazy.nvim loads plugins.
vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("options")
require("keymaps")
require("autocmds")
require("typst")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Loads every file in lua/plugins/
require("lazy").setup({ { import = "plugins" } }, {
  change_detection = { notify = false },
})
