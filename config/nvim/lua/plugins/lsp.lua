return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = { "saghen/blink.cmp" },
    config = function() require("lsp") end,
  },

  {
    "saghen/blink.cmp",
    version = "1.*", -- release builds ship a prebuilt binary
    opts = {
      keymap = {
        preset = "default", -- <C-Space> open, <C-n>/<C-p> select, <C-y> accept
        ["<C-l>"] = { "accept", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        -- <Tab> accepts a Copilot suggestion when one is showing
        ["<Tab>"] = {
          function()
            local ok, s = pcall(require, "copilot.suggestion")
            if ok and s.is_visible() then s.accept() return true end
          end,
          "snippet_forward", "fallback",
        },
        ["<S-Tab>"] = {
          function()
            local ok, s = pcall(require, "copilot.suggestion")
            if ok and s.is_visible() then s.accept_word() return true end
          end,
          "snippet_backward", "fallback",
        },
      },
      completion = { documentation = { auto_show = true } },
    },
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        auto_trigger = true,
        keymap = { accept = false, accept_word = false }, -- handled by blink above
      },
      filetypes = { typst = false, markdown = false, tex = false, gitcommit = false },
    },
  },
}
