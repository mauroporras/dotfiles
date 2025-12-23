return {
  "mattn/emmet-vim",
  ft = { "html", "css", "scss", "javascriptreact", "typescriptreact", "vue", "svelte" },
  init = function()
    vim.g.user_emmet_mode = "i"
  end,
}
