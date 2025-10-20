return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { 
                    "lua_ls",
                    "pyright",
                    "clangd",
                    "ts_ls",
                    "bashls",
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()

            vim.lsp.config('lua_ls', {
                cmd = { "lua-language-server" },
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                    },
                },
            })

            vim.lsp.config('bashls', {
                capabilities = capabilities,
            })

            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })
            vim.keymap.set("n", "<C-.>", vim.lsp.buf.definition, { desc = "Go to Definition" })
            vim.keymap.set("n", "<C-a>", vim.lsp.buf.code_action, { desc = "Code Action" })
        end,
    },
}

