-- vim:foldmethod=marker

-- To reload config:
-- :source %
-- :so $MYVIMRC

-- Note: `:source %` won't reload required files (cached in package.loaded)
--
-- Order matters:
-- - Plugin manager loads early so keymaps/autocommands can override plugin defaults
-- - Highlights must load after the colorscheme so they don't get overridden
require("00_settings")
require("01_lazy_plugin_manager")
-- require("plugins_packer_deprecated")
require("02_keymaps")
require("03_autocommands")
require("04_highlights")
require("05_snippets")
