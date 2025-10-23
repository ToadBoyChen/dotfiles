return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    -- Your new ASCII art header
    local header_lines = {
      [[                                         ▐            ▐ ]],
      [[         ▐                      █        █            █ ]],
      [[ ███▄    █  ▓█████   ▒█████    ██▒   █▓  ██▓  ███▄ ▄███▓]],
      [[ ██ ▀█   █  ▓█   ▀  ▒██▒  ██▒ ▓██░   █▒▓ ██▒▓ ██▒▀█▀ ██▒]],
      [[▓██  ▀█ ██ ▒▒███    ▒██░  ██▒  ▓██  █▒░▒ ██▒▓ ██    ▓██░]],
      [[▓██▒  ▐▌██ ▒▒▓█  ▄  ▒██   ██░   ▒██ █░░░ ██░▒ ██    ▒██ ]],
      [[▒██░   ▓██ ░░▒████▒ ░ ████▓▒░    ▒▀█░  ░ ██░▒ ██▒   ░██▒]],
      [[▐█ ▒░  ▒ ▒  ░░ ▒░ ░ ░ ▒░▒░▒░     ░ ▐░  ░ ▓  ░ █▒░   ░█ ░]],
      [[█ ░    ░ ▒ ░ ░ ░  ░   ░ ▒ ▒░     ░ ░░    ▒ ░░ █ ░      ░]],
      [[▐  ░   ░ ░     ░    ░ ░ ░ ▒        ░░    ▒ ░░ ▐     ░   ]],
      [[         ░     ░  ░     ░ ░         ░    ░          ░   ]],
      [[                                  ░                     ]],
      [[                                                        ]],
      [[                                                        ]],
    }

    -- Gradient highlight groups
    local hl_groups = {
      "Title", "Function", "Type", "String", "Keyword", "Number", "Identifier", "Constant"
    }

    local function ensure_hl_exists(name)
      local ok = pcall(vim.api.nvim_get_hl, 0, { name = name })
      if not ok then vim.api.nvim_set_hl(0, name, {}) end
    end
    for _, g in ipairs(hl_groups) do ensure_hl_exists(g) end

    -- Dashboard setup
    require('dashboard').setup {
      theme = 'doom',
      config = {
        header = header_lines,
        center = {
          { icon = '  ', desc = 'New File',       key = 'n', action = 'enew' },
          { icon = '  ', desc = 'Find File',      key = 'f', action = 'Telescope find_files' },
          { icon = '  ', desc = 'Recent Files',   key = 'r', action = 'Telescope oldfiles' },
          { icon = '  ', desc = 'Update Plugins', key = 'u', action = 'Lazy update' },
          { icon = '  ', desc = 'Quit',           key = 'q', action = 'qa' },
        },
        footer = { "TOADBOYCHEN1337" },
        vertical_center = true,
      },
    }

    -- Apply gradient highlight to the ASCII header
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "dashboard",
      callback = function(args)
        local bufnr = args.buf
        local ns = vim.api.nvim_create_namespace("dashboard_header_ns")
        for i, _ in ipairs(header_lines) do
          local group = hl_groups[((i - 1) % #hl_groups) + 1]
          vim.api.nvim_buf_add_highlight(bufnr, ns, group, i - 1, 0, -1)
        end
      end,
    })
  end,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}

