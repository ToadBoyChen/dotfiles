return {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal right<CR>")

        require("neo-tree").setup({
            filesystem = {
                window = {
                    position = "right", 
                    width = 25,
                },
                follow_current_file = { enabled = true },
            },
        })
    end,
}


