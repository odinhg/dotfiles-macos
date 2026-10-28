return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.install({
        "bash", "c", "cpp", "css", "diff", "html", "json", "latex", "lua", "luadoc",
        "markdown", "markdown_inline", "nix", "python", "query", "toml", "typst",
        "vim", "vimdoc", "yaml",
      })
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
          if not lang or not pcall(vim.treesitter.start, ev.buf, lang) then return end
          if vim.treesitter.query.get(lang, "indents") then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          mappings = { i = { ["<C-u>"] = false, ["<C-d>"] = false, ["<Esc>"] = actions.close } },
        },
      })
      -- Wrap long lines in the preview so grep matches are visible without opening the file.
      vim.api.nvim_create_autocmd("User", {
        pattern = "TelescopePreviewerLoaded",
        callback = function() vim.wo.wrap = true end,
      })
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim", "nvim-tree/nvim-web-devicons" },
    opts = {},
  },

  { "lewis6991/gitsigns.nvim", event = { "BufReadPre", "BufNewFile" }, opts = {} },
  { "akinsho/toggleterm.nvim", version = "*", cmd = "ToggleTerm", opts = {} },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {
      keys = {
        -- Code action on the item without leaving the list (e.g. add a word
        -- to harper's dictionary). Moves the main window's cursor to the item.
        a = {
          action = function(view)
            local item, main = view:at().item, view:main()
            if not (item and item.buf and main) then return end
            vim.api.nvim_win_set_buf(main.win, item.buf)
            vim.api.nvim_win_set_cursor(main.win, item.pos)
            vim.api.nvim_win_call(main.win, vim.lsp.buf.code_action)
          end,
          desc = "Code action",
        },
      },
    },
  },
  { "kdheepak/lazygit.nvim", cmd = "LazyGit", dependencies = { "nvim-lua/plenary.nvim" } },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "┊" },
      exclude = {
        filetypes = { "help", "lazy", "neo-tree", "toggleterm", "typst", "markdown", "tex", "text", "gitcommit" },
      },
    },
  },
}
