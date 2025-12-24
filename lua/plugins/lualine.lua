-- Statusline and winbar.
return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  config = function()
    local custom_theme = require("lualine.themes.codedark")

    custom_theme.inactive.c = {
      bg = "gray",
      fg = "lightgray",
    }

    require("lualine").setup({
      options = {
        theme = custom_theme,
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
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "location" },
      },
      winbar = {
        lualine_a = { "filename" },
      },
      inactive_winbar = {
        lualine_c = { "filename" },
      },
    })
  end,
}
