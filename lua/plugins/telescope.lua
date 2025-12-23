-- Old command for fzf was:
-- ```bash
-- rg --files --follow --hidden --smart-case --no-ignore-vcs --glob '!{.git,dist,node_modules,tags}'
-- ```
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "kkharji/sqlite.lua",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-frecency.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-smart-history.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
  },
  keys = {
    { "<Leader>a", "<cmd>Telescope live_grep<CR>", desc = "Search in all files" },
    { "<Leader>A", "<cmd>Telescope grep_string<CR>", desc = "Search string under cursor" },
    { "<Leader>b", "<cmd>Telescope buffers<CR>", desc = "List buffers" },
    { "<Leader>gd", "<cmd>Telescope lsp_definitions<CR>", desc = "LSP definitions" },
    { "<Leader>gi", "<cmd>Telescope lsp_implementations<CR>", desc = "LSP implementations" },
    { "<Leader>gr", "<cmd>Telescope lsp_references<CR>", desc = "LSP references" },
    { "<Leader>gs", "<cmd>Telescope lsp_document_symbols<CR>", desc = "LSP document symbols" },
    { "<Leader>O", "<cmd>Telescope frecency workspace=CWD<CR>", desc = "Frecency file picker" },
    { "<Leader>o", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<Leader>vc", "<cmd>Telescope git_bcommits<CR>", desc = "Buffer git commits" },
    { "<Leader>zl", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Fuzzy find in buffer" },
    { "<Leader>zh", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
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
          height = 999,
          prompt_position = "top",
          scroll_speed = 3,
          width = 999,
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
            ["<C-q>"] = require("telescope.actions").smart_send_to_qflist
              + require("telescope.actions").open_qflist,
            ["<C-d>"] = false,
            ["<C-u>"] = false,
          },
        },
        prompt_prefix = "",
      },
      extensions = {
        frecency = {
          -- Stale entries won't be automatically removed and
          -- the prompt won't show up.
          auto_validate = false,
          show_scores = true,
        },
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
    })

    telescope.load_extension("frecency")
    telescope.load_extension("fzf")
    telescope.load_extension("smart_history")
    telescope.load_extension("ui-select")
  end,
}
