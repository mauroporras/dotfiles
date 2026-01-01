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
    -- Lua utility library used by many plugins
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

    "nvim-tree/nvim-web-devicons",

    "kkharji/sqlite.lua",
    -- See `:h telescope-frecency-configuration`
    "nvim-telescope/telescope-frecency.nvim",
    "nvim-telescope/telescope-smart-history.nvim",
    -- Replaces vim.ui.select with Telescope picker
    "nvim-telescope/telescope-ui-select.nvim",
  },
  keys = {
    {
      "<Leader>a",
      function()
        require("telescope.builtin").live_grep({ prompt_title = "Search in all files" })
      end,
      desc = "Search in all files",
    },
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
    {
      "<Leader>*",
      function()
        require("telescope.builtin").grep_string({ prompt_title = "Search word under cursor" })
      end,
      desc = "Search word under cursor",
    },
    {
      "<Leader>b",
      function()
        require("telescope.builtin").buffers({
          prompt_title = "Buffers",
          previewer = false,
        })
      end,
      desc = "List buffers",
    },
    -- Jump to the definition of the word under your cursor.
    -- This is where a variable was first declared, or where a function is defined, etc.
    -- To jump back, press <C-t>.
    {
      "<Leader>gd",
      function()
        require("telescope.builtin").lsp_definitions({ prompt_title = "LSP Definitions" })
      end,
      desc = "LSP definitions",
    },
    -- Jump to the implementation of the word under your cursor.
    -- Useful when your language has ways of declaring types without an actual implementation.
    {
      "<Leader>gi",
      function()
        require("telescope.builtin").lsp_implementations({ prompt_title = "LSP Implementations" })
      end,
      desc = "LSP implementations",
    },
    -- Find references for the word under your cursor.
    {
      "<Leader>gr",
      function()
        require("telescope.builtin").lsp_references({ prompt_title = "LSP References" })
      end,
      desc = "LSP references",
    },
    -- Fuzzy find all the symbols in your current document.
    -- Symbols are things like variables, functions, types, etc.
    {
      "<Leader>gs",
      function()
        require("telescope.builtin").lsp_document_symbols({ prompt_title = "Document Symbols" })
      end,
      desc = "LSP document symbols",
    },
    -- Fuzzy find all the symbols in your current workspace.
    -- Similar to document symbols, except searches over your entire project.
    {
      "<Leader>gS",
      function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols({ prompt_title = "Workspace Symbols" })
      end,
      desc = "LSP workspace symbols",
    },
    -- Jump to the type of the word under your cursor.
    -- Useful when you're not sure what type a variable is and you want to see
    -- the definition of its *type*, not where it was *defined*.
    {
      "<Leader>gt",
      function()
        require("telescope.builtin").lsp_type_definitions({ prompt_title = "Type Definition" })
      end,
      desc = "LSP type definition",
    },
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
    {
      "<Leader>o",
      function()
        require("telescope.builtin").find_files({
          prompt_title = "Find files by name",
          previewer = false,
        })
      end,
      desc = "Find files",
    },
    {
      "<Leader>vh",
      function()
        require("telescope.builtin").git_bcommits({
          prompt_title = "Buffer Git Commits",
          git_command = { "git", "log", "--pretty=%h %an %ad: %s", "--date=short", "--follow", "--" },
        })
      end,
      desc = "Buffer git commits",
    },
    {
      "<Leader>/",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find({
          prompt_title = "Fuzzy Find in Buffer",
          tiebreak = function(current, existing)
            -- Prefer lower line numbers (earlier in file)
            return current.lnum < existing.lnum
          end,
        })
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
    {
      "<Leader>zr",
      function()
        require("telescope.builtin").resume({ prompt_title = "Resume Last Picker" })
      end,
      desc = "Resume last picker",
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local layout = require("telescope.actions.layout")

    local common_mappings = {
      ["<C-j>"] = "move_selection_next",
      ["<C-k>"] = "move_selection_previous",
      ["<C-n>"] = "cycle_history_next",
      ["<C-p>"] = "cycle_history_prev",
      ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
      ["<M-p>"] = layout.toggle_preview,
      ["<M-l>"] = layout.cycle_layout_next,
    }

    local databases_dir = vim.fn.stdpath("data") .. "/databases"
    vim.fn.mkdir(databases_dir, "p")

    telescope.setup({
      defaults = {
        dynamic_preview_title = true,
        history = {
          -- .sqlite3 extension required for telescope-smart-history.nvim
          -- See `:h telescope-smart-history.nvim-telescope-smart-history-nvim`
          path = databases_dir .. "/telescope_history.sqlite3",
        },
        -- :h telescope.layout
        layout_strategy = "vertical",
        layout_config = {
          height = { padding = 0 },
          width = { padding = 0 },
          prompt_position = "top",
          scroll_speed = 1,
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
        -- See `:h telescope.mappings`
        -- If the function you want is part of `telescope.actions`,
        -- then you can simply give a string.
        mappings = {
          i = vim.tbl_extend("force", common_mappings, {
            -- Disable to allow default insert mode editing (delete forward/backward)
            ["<C-d>"] = false,
            ["<C-u>"] = false,
          }),
          n = vim.tbl_extend("force", common_mappings, {
            ["J"] = "preview_scrolling_down",
            ["K"] = "preview_scrolling_up",
            ["q"] = "close",
          }),
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
        ---@module 'frecency'
        ---@type FrecencyOpts
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
