-- vim:foldmethod=marker

-- To reload config:
-- :source %
-- :so $MYVIMRC

-- Note: `:source %` won't reload required files (cached in package.loaded)
require("00_settings")
require("01_highlights")
require("02_keymaps")
require("03_autocommands")
require("04_lazy_plugin_manager")
-- require("plugins_packer_deprecated")
require("05_snippets")
