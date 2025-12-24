-- Fuzzy finder for files, buffers, grep, LSP, and more.
--
-- Old command for fzf was:
-- ```bash
-- rg --files --follow --hidden --smart-case --no-ignore-vcs --glob '!{.git,dist,node_modules,tags}'
-- ```
return {
  "nvim-telescope/telescope.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      "nvim-telescope/telescope-fzf-native.nvim",

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = "make",

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    { "nvim-telescope/telescope-ui-select.nvim" },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },

    "kkharji/sqlite.lua",
    "nvim-telescope/telescope-frecency.nvim",
    "nvim-telescope/telescope-smart-history.nvim",
  },
  keys = {
    { "<Leader>a", "<cmd>Telescope live_grep<CR>", desc = "Search in all files" },
    {
      "<Leader>A",
      function()
        require("telescope.builtin").live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end,
      desc = "Search in open files",
    },
    { "<Leader>*", "<cmd>Telescope grep_string<CR>", desc = "Search word under cursor" },
    { "<Leader>b", "<cmd>Telescope buffers<CR>", desc = "List buffers" },
    { "<Leader>gd", "<cmd>Telescope lsp_definitions<CR>", desc = "LSP definitions" },
    { "<Leader>gi", "<cmd>Telescope lsp_implementations<CR>", desc = "LSP implementations" },
    { "<Leader>gr", "<cmd>Telescope lsp_references<CR>", desc = "LSP references" },
    { "<Leader>gs", "<cmd>Telescope lsp_document_symbols<CR>", desc = "LSP document symbols" },
    -- No preview for faster file picking
    -- { "<Leader>R", "<cmd>Telescope frecency workspace=CWD<CR>", desc = "Frecency file picker" },
    {
      "<Leader>R",
      function()
        require("telescope").extensions.frecency.frecency({
          workspace = "CWD",
          previewer = false,
          prompt_title = "Frecency",
        })
      end,
      desc = "Frecency file picker",
    },
    { "<Leader>o", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<Leader>vc", "<cmd>Telescope git_bcommits<CR>", desc = "Buffer git commits" },
    {
      "<Leader>/",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          prompt_title = "Fuzzy Find in Buffer",
          layout_config = {
            width = { padding = 0 },
            height = { padding = 0 },
          },
        }))
      end,
      desc = "Fuzzy find in buffer",
    },
    -- No preview for faster file picking
    -- { "<Leader>O", "<cmd>Telescope oldfiles<CR>", desc = "Old (recent) files" },
    {
      "<Leader>O",
      function()
        require("telescope.builtin").oldfiles({
          previewer = false,
          prompt_title = "Old (recent) files",
        })
      end,
      desc = "Old (recent) files",
    },
    { "<Leader>zr", "<cmd>Telescope resume<CR>", desc = "Resume last picker" },
  },
  config = function()
    local telescope = require("telescope")

    telescope.setup({
      defaults = {
        dynamic_preview_title = true,
        history = {
          path = "~/.local/share/nvim/telescope_history.sqlite3",
          limit = 100,
        },
        -- :h telescope.layout
        layout_strategy = "vertical",
        layout_config = {
          height = { padding = 0 },
          width = { padding = 0 },
          prompt_position = "top",
          scroll_speed = 3,
        },
        sorting_strategy = "ascending",
        -- :h telescope.defaults.vimgrep_arguments
        vimgrep_arguments = {
          "rg",
          -- Defaults:
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          -- Custom:
          "--follow",
          "--hidden",
          -- Only respect rules in .rgignore since sometimes you want to search
          -- inside files that are ignored by Git
          "--no-ignore-vcs",
          "--sort=path",
        },
        -- See:
        -- :h telescope.mappings
        -- If the function you want is part of `telescope.actions`,
        -- then you can simply give a string.
        mappings = {
          i = {
            ["<C-n>"] = "cycle_history_next",
            ["<C-p>"] = "cycle_history_prev",
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<C-q>"] = require("telescope.actions").smart_send_to_qflist + require("telescope.actions").open_qflist,
            ["<C-d>"] = false,
            ["<C-u>"] = false,
          },
        },
        prompt_prefix = "",
      },
      pickers = {
        -- :h telescope.builtin.find_files
        find_files = {
          find_command = {
            "rg",
            "--files",
            "--follow",
            "--hidden",
            "--smart-case",
            -- Only respect rules in .rgignore since sometimes you want to search
            -- inside files that are ignored by Git
            "--no-ignore-vcs",
            "--sort=path",
          },
        },
      },
      extensions = {
        frecency = {
          -- Stale entries won't be automatically removed and
          -- the prompt won't show up.
          auto_validate = false,
          show_scores = true,
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })

    telescope.load_extension("frecency")
    telescope.load_extension("fzf")
    telescope.load_extension("smart_history")
    telescope.load_extension("ui-select")
  end,
}
