return { 
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function() 
    local config = require("nvim-treesitter.configs")
    config.setup({
      ensure_installed = {
        "lua",
        "python", 
        "typescript", 
        "java", 
        "cpp", 
        "html", 
        "css",
        "markdown",          -- 🟢 REQUIRED for render-markdown
        "markdown_inline",   -- 🟢 REQUIRED for inline elements ($math$, links, etc.)
      },
      highlight = { enable = true },
      indent = { enable = true },
      -- Optional: Treesitter-based folding (nice for long notes)
      fold = { enable = true },
    })
  end,
}

