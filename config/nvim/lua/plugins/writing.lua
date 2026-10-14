return {
  {
    "lervag/vimtex",
    lazy = false, -- VimTeX asks not to be lazy-loaded
    init = function()
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_quickfix_open_on_warning = 0
      vim.g.vimtex_compiler_latexmk = {
        options = { "-verbose", "-file-line-error", "-synctex=1", "-interaction=nonstopmode", "-shell-escape" },
      }
    end,
  },

  {
    "chomosuke/typst-preview.nvim",
    version = "1.*",
    ft = "typst",
    opts = {},
  },
}
