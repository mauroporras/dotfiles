return {
  "mattn/emmet-vim",
  ft = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
  init = function()
    vim.g.user_emmet_mode = "i"
  end,
}
