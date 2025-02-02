-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
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

-- TODO: Can I have an LLM tell me how to clean this up properly? lol
require('lazy').setup({
  -- My plugins
  'johnsaigle/cargo-expand.nvim',
  {
    'johnsaigle/github-permalink.nvim',
  },
  {
    'johnsaigle/semgrep-diagnostics.nvim',
    dependencies = { 'jose-elias-alvarez/null-ls.nvim' },
  },
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  'ThePrimeagen/rfceez',

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

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
  { 'folke/which-key.nvim',          opts = {} },
  { -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
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
    opts = {
      -- char = '┊',
      -- show_trailing_blankline_indent = true,
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',         opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },

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
    -- Configure highlighting for markdown. TODO probably broken
    highlight_groups = {
      ["@markup.markdown.code"] = { fg = "gold" },  --, bg = "..." },
      ["@markup.markdown.block"] = { fg = "gold" }, --, bg = "..." },
      -- ["@markup.raw.block.markdown"] = { fg = "gold"}, --, bg = "..." },
      -- ["@markup.raw.delimiter.markdown"] = { fg = "gold"}, --, bg = "..." },
    }
    -- dependencies = {
    --   'nvim-treesitter/nvim-treesitter-textobjects',
    -- },
    -- config = function()
    --   pcall(require('nvim-treesitter.install').update { with_sync = true })
    -- end,
  },
  -- Go tools
  -- https://github.com/ray-x/go.nvim?tab=readme-ov-file#lazynvim
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      -- require("go").setup()
      require("go")
    end,
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
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
  { -- Trouble configuration (better experience with diagnostics)
    "folke/trouble.nvim",
    opts = {
      win = {
        wo = {
          wrap = true,
        },
      },
    },
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },

  -- NOTE: The import below automatically adds your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  --
  --    An additional note is that if you only copied in the `init.lua`, you can just comment this line
  --    to get rid of the warning telling you that there are not plugins in `lua/custom/plugins/`.
  { import = 'custom.plugins' },
}, {})

-- [[ Colour Scheme ]]
require("rose-pine").setup({
  highlight_groups = {
    -- Change comments to "gold" but as defined in the dawn variant of the colorscheme to make sure comments don't conflict with anything else
    Comment = { fg = "#ea9d34" },
    -- Make cursor line a darker version of "iris", approaching "base"
    CursorLine = { bg = "#5f4e75"},
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

-- [[ Go - ray-x go.nvim ]]
local goconfig = require("goconfig")
require('go').setup(goconfig)

-- [[ GoPls ]]
require 'gopls'

-- [[ devcontainer support ]]
require("devcontainer").setup {}

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

-- Cargo Expand
local cargo_expand = require('cargo-expand.expand')
require('cargo-expand').setup({})
vim.keymap.set("n", "<leader>ce", cargo_expand.expand, { desc = "[C]argo [E]xpand" })

-- [ GitHub Permalink ]
require('github-permalink').setup({})
-- Using <C-u> clears the highlight after generating the link.
vim.keymap.set("x", "<leader>gl", ":<C-u>GitHubPermalink<CR>", { desc = "[G]itHub Perma[L]ink"} )

-- Semgrep Diagnostics
local semgrep_diagnostics = require('semgrep-diagnostics')
require('semgrep-diagnostics').setup({
  filetypes = { "sh", "bash", "rust", "go", "solidity" },
  semgrep_config = {
    "p/trailofbits",
    "~/coding/semgrep-rules"
  },
  default_severity = vim.diagnostic.severity.INFO,
})
vim.keymap.set("n", "<leader>tt", semgrep_diagnostics.toggle, { desc = "[T]oggle Semgrep diagnostics" })
vim.keymap.set("n", "<leader>tc", semgrep_diagnostics.print_config, { desc = "Print Semgrep diagnostics [C]onfig" })
vim.keymap.set('n', '<leader>td', semgrep_diagnostics.show_rule_details, { desc = 'Show Semgrep rule [D]etails' })
vim.keymap.set('n', '<leader>ts', semgrep_diagnostics.semgrep, { desc = 'Run [S]emgrep' })

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').load_extension('harpoon')
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

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
  -- note: go is configured via go.nvim
  bashls = {},
  pyright = {},
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

-- Rust LSP configuration
require('lspconfig').rust_analyzer.setup {
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = true,
        experimental = {
          enable = true
        }
      },
      -- Note the below doesn't seem to work: only `cargo check` runs
      check = {
        enable = true,
        -- command = "clippy",
        command = "cargo clippy --workspace --message-format=json --all-targets"
      },
      checkOnSave = {
        enable = true,
        -- command = "clippy",
        command = "cargo clippy --workspace --message-format=json --all-targets"
      },
    }
  }
}

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
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
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
