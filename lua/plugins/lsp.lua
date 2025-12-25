-- LSP Configuration
-- Adapted from kickstart.nvim
return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    -- Main LSP Configuration
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Useful status updates for LSP.
      { "j-hui/fidget.nvim", opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      "saghen/blink.cmp",
    },
    config = function()
      -- This function gets run when an LSP attaches to a particular buffer.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has("nvim-0.11") == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- Highlight references of the word under cursor when cursor rests there.
          -- See `:h CursorHold`
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if
            client
            and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
          then
            local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          -- Toggle inlay hints if the language server supports them
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map("<leader>ch", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "Toggle Inlay [H]ints")
          end
        end,
      })

      -- Diagnostic Config
      -- See :h vim.diagnostic.Opts
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        },
        virtual_text = {
          source = "if_many",
          spacing = 2,
          format = function(diagnostic)
            return diagnostic.message
          end,
        },
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      -- By default, Neovim doesn't support everything that is in the LSP specification.
      -- When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Enable the following language servers
      -- Add any additional override configuration in the following tables:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities
      --  - settings (table): Override the default settings passed when initializing the server
      local servers = {
        -- See `:h lspconfig-all` for a list of all the pre-configured LSPs
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ts_ls = {},

        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      -- To check the current status of installed tools: :Mason
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua", -- Lua formatter
      })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        ensure_installed = {},
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },
  { -- Autocompletion
    "saghen/blink.cmp",
    event = "VimEnter",
    version = "1.*",
    dependencies = {
      -- Snippet Engine
      {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        build = (function()
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        opts = {},
      },
      "folke/lazydev.nvim",
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' for mappings similar to built-in completions
        --   <c-y> to accept the completion
        --   <c-space>: Open menu or open docs if already open
        --   <c-n>/<c-p> or <up>/<down>: Select next/previous item
        --   <c-e>: Hide menu
        --   <c-k>: Toggle signature help
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = "default",
      },

      appearance = {
        -- 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        nerd_font_variant = "mono",
      },

      completion = {
        -- Press `<c-space>` to show the documentation.
        -- Set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { "lsp", "path", "snippets", "lazydev" },
        providers = {
          lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },

      snippets = { preset = "luasnip" },

      -- Use Lua fuzzy matcher (set to 'prefer_rust_with_warning' for rust implementation)
      fuzzy = { implementation = "lua" },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },
}
