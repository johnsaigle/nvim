--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    -- Mason is pinned to version 1 for now: https://github.com/LazyVim/LazyVim/issues/6039
    { "mason-org/mason.nvim",           version = "^1.0.0" },
    { "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },
    -- Git related plugins
    'tpope/vim-rhubarb',

    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',

    { -- LSP Configuration & Plugins
      'neovim/nvim-lspconfig',
      dependencies = {
        -- Automatically install LSPs to stdpath for neovim
        'mason-org/mason.nvim',
        'mason-org/mason-lspconfig.nvim',

        -- Useful status updates for LSP
        { 'j-hui/fidget.nvim', opts = {} },

        -- Additional lua configuration, makes nvim stuff amazing!
        'folke/neodev.nvim',
      },
    },
    -- call tree
    {
      'ldelossa/litee.nvim',
      event = "VeryLazy",
      opts = {
        notify = { enabled = false },
        panel = {
          orientation = "bottom",
          panel_size = 10,
        },
      },
      config = function(_, opts) require('litee.lib').setup(opts) end
    },

    {
      'ldelossa/litee-calltree.nvim',
      dependencies = 'ldelossa/litee.nvim',
      event = "VeryLazy",
      opts = {
        on_open = "panel",
        map_resize_keys = false,
      },
      config = function(_, opts) require('litee.calltree').setup(opts) end
    },

    { -- Autocompletion
      'hrsh7th/nvim-cmp',
      dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
    },
    {
      'https://codeberg.org/esensar/nvim-dev-container',
      dependencies = 'nvim-treesitter/nvim-treesitter'
    },

    -- Useful plugin to show you pending keybinds.
    { 'folke/which-key.nvim',  opts = {} },
    {
      "rose-pine/neovim", name = "rose-pine",
    },
    { -- Set lualine as statusline
      'nvim-lualine/lualine.nvim',
      -- See `:help lualine.txt`
      opts = {
        options = {
          icons_enabled = false,
          theme = 'rose-pine',
          component_separators = '|',
          section_separators = '',
          path = 3, -- absolute path, with tilde as home
        },
      },
    },

    { -- Add indentation guides even on blank lines
      'lukas-reineke/indent-blankline.nvim',
      main = "ibl",
      -- Enable `lukas-reineke/indent-blankline.nvim`
      -- See `:help indent_blankline.txt`
    },
    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim', opts = {} },
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { -- Highlight, edit, and navigate code
      'nvim-treesitter/nvim-treesitter',
      dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
      },
      build = ':TSUpdate',
      highlight_groups = {
        ["@markup.markdown.code"] = { fg = "gold" },
        ["@markup.markdown.block"] = { fg = "gold" },
      }
    },
    -- Rainbow highlighting for delimiters
    {
      'HiPhish/rainbow-delimiters.nvim',
    },
    -- CodeQL support
    {
      "pwntester/codeql.nvim",
      dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/telescope.nvim",
        "kyazdani42/nvim-web-devicons",
        {
          's1n7ax/nvim-window-picker',
          version = 'v1.*',
          opts = {
            autoselect_one = true,
            include_current = false,
            filter_rules = {
              bo = {
                filetype = {
                  "codeql_panel",
                  "codeql_explorer",
                  "qf",
                  "TelescopePrompt",
                  "TelescopeResults",
                  "notify",
                  "noice",
                  "NvimTree",
                  "neo-tree",
                },
                buftype = { 'terminal' },
              },
            },
            current_win_hl_color = '#e35e4f',
            other_win_hl_color = '#44cc41',
          },
        }
      },
      opts = {}
    },
    { import = 'custom.plugins' },
  },
  -- second argument for lazy.setup()
  {
    change_detection = { notify = false }
  }
)


-- [[ Colour Scheme ]]
require("rose-pine").setup({
  highlight_groups = {
    -- Change comments to "gold" but as defined in the dawn variant of the colorscheme to make sure comments don't conflict with anything else
    Comment = { fg = "#ea9d34" },
    -- Make cursor line a darker version of "iris", approaching "base"
    CursorLine = { bg = "#5f4e75" },
    -- Doesn't seem to work, still ends up with the 'subtle' colour. Maybe overridden by Avante?
    -- Visual = { bg = "iris" },
  },
})
vim.cmd("colorscheme rose-pine-moon")

-- Manual overrides for Rose Pine. The latest release does not have these fields but they exist in main.
vim.api.nvim_set_hl(0, "CurSearch", {
  bg = "#eb6f92", -- Rose Pine - "love"
  fg = "#ffffff",
  bold = true,
  -- TODO Doesn't seem to work. Font issue or something else?
  italic = true
})
vim.api.nvim_set_hl(0, "Search", {
  bg = "#c4a7e7", -- Rose Pine - "iris"
  fg = "#eeeeee",
  -- TODO Doesn't seem to work. Font issue or something else?
  italic = true
})

-- Add files from the lua/ folder

-- [[ Basic Keymaps ]]
require 'keymaps'

-- [[ Harpoon ]]
local harpoon = require('harpoon')
harpoon:setup({})

-- [[ Vim options ]]
require 'options'

-- [[ Treesitter ]]
require 'treesitter'

-- [[ devcontainer support ]]
require("devcontainer").setup {}

require('telescope').load_extension('harpoon')
-- Harpoon shorcuts
vim.keymap.set("n", "<leader>f", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-f>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<C-j>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-k>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-l>", function() harpoon:list():select(3) end)
-- TODO this doesn't respond: `;` is used for horizontal seeking
-- vim.keymap.set("n", "<C-;>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gC', require('telescope.builtin').lsp_incoming_calls, '[G]oto In[C]oming calls')
  nmap('gG', require('telescope.builtin').lsp_outgoing_calls, '[G]oto Out[G]oing calls')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')


  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<leader>k', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  bashls = {},
  pyright = {},
  gopls = {},
  -- Configure rust-analyzer like the other plugins, but it should be managed with rustup.
  -- Use `:!which rust-analyzer` and make sure it's NOT installed by Mason.
  rust_analyzer = {},
  yamlls = {},
  solidity_ls = {},
  -- tsserver = {},

  lua_ls = {
    Lua = {
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library"
        },
      },
      telemetry = { enable = false },
    },
  },
}

-- local plsconfig = {
--   cmd = { vim.fn.expand("~/perl5/bin/pls") }, -- complete path to where PLS is located
--   settings = {
--     pls = {
--       perlcritic = { enabled = true },
--       syntax = { enabled = true },
--     },
--   }
-- }
-- -- require('lspconfig').perlpls.setup(plsconfig)

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<C-n>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<C-p>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'supermaven' },
    { name = 'treesitter' },
  },
}

-- Configure raindow delimiters

-- This module contains a number of default definitions
local rainbow_delimiters = require 'rainbow-delimiters'

---@type rainbow_delimiters.config
require('rainbow-delimiters.setup').setup {
  strategy = {
    [''] = rainbow_delimiters.strategy['global'],
    vim = rainbow_delimiters.strategy['local'],
  },
  query = {
    [''] = 'rainbow-delimiters',
    lua = 'rainbow-blocks',
  },
  priority = {
    [''] = 110,
    lua = 210,
  },
  highlight = {
    'RainbowDelimiterRed',
    'RainbowDelimiterYellow',
    'RainbowDelimiterBlue',
    'RainbowDelimiterOrange',
    'RainbowDelimiterGreen',
    'RainbowDelimiterViolet',
    'RainbowDelimiterCyan',
  },
}

local highlight = {
  "RainbowRed",
  "RainbowYellow",
  "RainbowBlue",
  "RainbowOrange",
  "RainbowGreen",
  "RainbowViolet",
  "RainbowCyan",
}

-- Configure IBL hooks to use rainbow highlighting for indentation lines
local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
  vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
  vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
  vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
  vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
  vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
  vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

vim.g.rainbow_delimiters = { highlight = highlight }
require("ibl").setup { scope = { highlight = highlight } }

hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

-- Quint support
-- TODO convert this vimscript into a lua autocmd
-- autocmd FileType quint lua vim.lsp.start({name = 'quint', cmd = {'quint-language-server', '--stdio'}, root_dir = vim.fs.dirname()})
--  au BufRead,BufNewFile *.qnt
--  setfiletype quint

--- Install Sway LSP as a custom	server
local lspconfig = require 'lspconfig'
local configs = require 'lspconfig.configs'

-- Check if the config is already defined (useful when reloading this file)
if not configs.sway_lsp then
  configs.sway_lsp = {
    default_config = {
      cmd = { 'forc-lsp' },
      filetypes = { 'sway' },
      on_attach = on_attach,
      init_options = {
        -- Any initialization options
        logging = { level = 'trace' }
      },
      root_dir = function(fname)
        return lspconfig.util.find_git_ancestor(fname)
      end,
      settings = {},
    },
  }
end

lspconfig.sway_lsp.setup {}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
