return { 
    "nvim-neo-tree/neo-tree.nvim", 
    dependencies = { 
        "nvim-tree/nvim-web-devicons", 
        "MunifTanjim/nui.nvim", 
    },
    config = function()
        vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left <CR>")
    end
}
