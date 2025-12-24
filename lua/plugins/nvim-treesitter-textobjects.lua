-- Treesitter textobjects for selecting, moving, and swapping code elements.
-- See:
--   https://github.com/nvim-treesitter/nvim-treesitter-textobjects
return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = "VeryLazy",
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = {
        lookahead = true,
        include_surrounding_whitespace = false,
      },
      move = {
        set_jumps = true,
      },
    })

    local select = require("nvim-treesitter-textobjects.select")
    local move = require("nvim-treesitter-textobjects.move")
    local swap = require("nvim-treesitter-textobjects.swap")

    -- Select textobjects
    vim.keymap.set({ "x", "o" }, "af", function() select.select_textobject("@function.outer", "textobjects") end, { desc = "Around function" })
    vim.keymap.set({ "x", "o" }, "if", function() select.select_textobject("@function.inner", "textobjects") end, { desc = "Inner function" })
    vim.keymap.set({ "x", "o" }, "ac", function() select.select_textobject("@class.outer", "textobjects") end, { desc = "Around class" })
    vim.keymap.set({ "x", "o" }, "ic", function() select.select_textobject("@class.inner", "textobjects") end, { desc = "Inner class" })
    vim.keymap.set({ "x", "o" }, "aa", function() select.select_textobject("@parameter.outer", "textobjects") end, { desc = "Around argument" })
    vim.keymap.set({ "x", "o" }, "ia", function() select.select_textobject("@parameter.inner", "textobjects") end, { desc = "Inner argument" })

    -- Move to next/prev function
    vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end, { desc = "Next function start" })
    vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Prev function start" })
    vim.keymap.set({ "n", "x", "o" }, "]F", function() move.goto_next_end("@function.outer", "textobjects") end, { desc = "Next function end" })
    vim.keymap.set({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@function.outer", "textobjects") end, { desc = "Prev function end" })

    -- Move to next/prev class
    vim.keymap.set({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer", "textobjects") end, { desc = "Next class start" })
    vim.keymap.set({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer", "textobjects") end, { desc = "Prev class start" })
    vim.keymap.set({ "n", "x", "o" }, "]C", function() move.goto_next_end("@class.outer", "textobjects") end, { desc = "Next class end" })
    vim.keymap.set({ "n", "x", "o" }, "[C", function() move.goto_previous_end("@class.outer", "textobjects") end, { desc = "Prev class end" })

    -- Move to next/prev argument
    vim.keymap.set({ "n", "x", "o" }, "]a", function() move.goto_next_start("@parameter.inner", "textobjects") end, { desc = "Next argument" })
    vim.keymap.set({ "n", "x", "o" }, "[a", function() move.goto_previous_start("@parameter.inner", "textobjects") end, { desc = "Prev argument" })

    -- Swap arguments
    vim.keymap.set("n", "<Leader>cs", function() swap.swap_next("@parameter.inner") end, { desc = "Swap with next argument" })
    vim.keymap.set("n", "<Leader>cS", function() swap.swap_previous("@parameter.inner") end, { desc = "Swap with prev argument" })
  end,
}
