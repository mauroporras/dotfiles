-- Statusline and winbar.
return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local custom_theme = require("lualine.themes.codedark")

    custom_theme.inactive.c = {
      bg = "gray",
      fg = "lightgray",
    }

    require("lualine").setup({
      options = {
        theme = custom_theme,
        -- Display a single statusline for the entire Neovim instance.
        globalstatus = true,
      },
      sections = {
        lualine_a = {},
        lualine_b = {
          "diagnostics",
        },
        lualine_c = {
          {
            "filename",
            path = 1,
          },
          "navic",
        },
        -- lualine_x = {},
        -- lualine_y = {},
        -- lualine_z = { "location" },
      },
      winbar = {
        lualine_a = { { "filename", path = 4 } },
      },
      inactive_winbar = {
        lualine_c = { { "filename", path = 4 } },
      },
    })
  end,
}
