return {
    "nvim-lualine/lualine.nvim",
    config = function()
        require("lualine").setup({
            options = {
                theme = "molokai",
                globalstatus = true,
            },
        })
    end,
}

