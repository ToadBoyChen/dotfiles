return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    cmdline = {
      view = "cmdline_popup",
      format = {
        cmdline = { icon = ":", lang = "vim" },
        search_down = { kind = "search", pattern = "^/", icon = "/", lang = "regex" },
        search_up = { kind = "search", pattern = "^%?", icon = "?", lang = "regex" },
      },
    },
    views = {
      cmdline_popup = {
        position = {
          row = "95%",
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
        },
      },
    },
  },
}
