return {
  {
    "zenbones-theme/zenbones.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    lazy = false,
    priority = 1000,
    config = function() vim.cmd.colorscheme("duckbones") end,
  },

  {
    "romgrk/barbar.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {},
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        globalstatus = true,
        component_separators = "",
        section_separators = "",
      },
      sections = {
        lualine_a = { { "mode", fmt = function(s) return s:sub(1, 1) end } },
        lualine_b = { "branch", "diff" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = {
          -- Word count in prose buffers
          {
            function()
              local wc = vim.fn.wordcount()
              return (wc.visual_words or wc.words) .. " words"
            end,
            cond = function()
              return vim.tbl_contains({ "typst", "markdown", "tex", "text" }, vim.bo.filetype)
            end,
          },
          "diagnostics",
        },
        lualine_y = { "filetype" },
        lualine_z = { "location" },
      },
      extensions = { "neo-tree", "lazy" },
    },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
}
