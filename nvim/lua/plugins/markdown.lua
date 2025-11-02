return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons", -- optional, for icons/symbols
  },
  opts = {
    latex = {
      enabled = true, -- ✅ enable LaTeX-style math rendering
    },
    heading = {
      icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
      signs = false,
    },
  },
}

