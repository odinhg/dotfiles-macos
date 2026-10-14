-- Language servers. Binaries come from Nix (home.nix), defaults from
-- nvim-lspconfig, and the settings here are merged on top.

vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

vim.lsp.config("harper_ls", require("harper"))

vim.lsp.config("pyright", {
  settings = {
    pyright = { disableOrganizeImports = true }, -- ruff does this
    python = { analysis = { typeCheckingMode = "basic" } },
  },
})

vim.lsp.config("tinymist", {
  settings = {
    formatterMode = "typstyle",
    semanticTokens = "disable",
  },
})

vim.lsp.enable({ "harper_ls", "pyright", "ruff" })

-- tinymist is off by default because its memory use grows on large
-- projects. Start it by hand when you want completion and go-to-definition.
vim.api.nvim_create_user_command("TinymistStart", function()
  vim.lsp.enable("tinymist")
  vim.cmd("silent! doautoall FileType")
end, { desc = "Start tinymist for this session" })
