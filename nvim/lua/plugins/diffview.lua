return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("diffview").setup({
        enhanced_diff_hl = true,
        use_icons = true,
        view = {
          default = {
            layout = "diff2_horizontal", 
          },
          merge_tool = {
            layout = "diff3_horizontal",
            disable_diagnostics = true,
          },
        },
        file_panel = {
          listing_style = "tree", 
          win_config = { position = "left", width = 35 },
        },
        keymaps = {
          view = {
            ["<leader>e"] = require("diffview.config").actions.focus_files,
            ["<leader>c"] = require("diffview.config").actions.toggle_files,
          },
        },
      })
    end,
  },
}

