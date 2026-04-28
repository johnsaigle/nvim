local function telescope_builtin(name)
  return function()
    require('telescope.builtin')[name]()
  end
end

local function current_buffer_fuzzy_find()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end

local function search_dirs_picker(picker, search_dirs, prompt_title)
  return function()
    require('telescope.builtin')[picker] {
      search_dirs = search_dirs,
      prompt_title = prompt_title,
    }
  end
end

local function go_search_dirs()
  local goroot = vim.fn.system('go env GOROOT'):gsub('\n', '')
  local gopath = vim.fn.system('go env GOPATH'):gsub('\n', '')

  return {
    vim.fs.joinpath(goroot, 'src'),
    vim.fs.joinpath(gopath, 'pkg', 'mod'),
  }
end

return {
  'nvim-telescope/telescope.nvim',
  version = '*',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = { 'Telescope' },
  keys = {
    { '<leader>?', telescope_builtin 'oldfiles', desc = '[?] Find recently opened files' },
    { '<leader><space>', telescope_builtin 'buffers', desc = '[ ] Find existing buffers' },
    { '<leader>/', current_buffer_fuzzy_find, desc = '[/] Fuzzily search in current buffer' },
    { '<leader>sf', telescope_builtin 'find_files', desc = '[S]earch [F]iles' },
    { '<leader>sh', telescope_builtin 'help_tags', desc = '[S]earch [H]elp' },
    { '<leader>sg', telescope_builtin 'live_grep', desc = '[S]earch by [G]rep' },
    { '<leader>st', telescope_builtin 'git_files', desc = '[S]earch gi[T] files' },
    { '<leader>sa', search_dirs_picker('live_grep', { '~/audits' }, 'Search audit notes directory'), desc = '[S]earch in [A]udit notes' },
    { '<leader>sn', search_dirs_picker('live_grep', { '~/notes' }, 'Search notes'), desc = '[S]earch [N]otes' },
    {
      '<leader>so',
      search_dirs_picker('live_grep', {
        vim.fs.joinpath('~/coding/', 'agave'),
        vim.fs.joinpath('~/coding/', 'anchor'),
        vim.fs.joinpath('~/coding/', 'associated-token-account'),
        vim.fs.joinpath('~/coding/', 'solana-spl-token'),
        vim.fs.joinpath('~/coding/', 'token'),
        vim.fs.joinpath('~/coding/', 'token-2022'),
        vim.fs.joinpath('~/coding/', 'sbpf'),
      }, 'Grep in Solana and Anchor files'),
      desc = '[S]earch in S[o]lana source lines',
    },
    {
      '<leader>sO',
      search_dirs_picker('find_files', {
        vim.fs.joinpath('~/coding/', 'agave'),
        vim.fs.joinpath('~/coding/', 'anchor'),
        vim.fs.joinpath('~/coding/', 'associated-token-account'),
        vim.fs.joinpath('~/coding/', 'solana-spl-token'),
        vim.fs.joinpath('~/coding/', 'token-2022'),
        vim.fs.joinpath('~/coding/', 'sbpf'),
        vim.fs.joinpath('~/coding/', 'system'),
      }, 'Find Solana and Anchor files'),
      desc = '[S]earch in S[O]lana source (big O)',
    },
    {
      '<leader>sc',
      search_dirs_picker('find_files', {
        vim.fs.joinpath('~/coding/', 'cosmos-sdk'),
        vim.fs.joinpath('~/coding/', 'cometbft'),
        vim.fs.joinpath('~/coding/', 'gaia'),
      }, 'Find Cosmos files'),
      desc = '[S]earch in [C]osmos source files',
    },
    {
      '<leader>sC',
      search_dirs_picker('find_files', {
        vim.fs.joinpath('~/coding/', 'cosmos-sdk'),
        vim.fs.joinpath('~/coding/', 'cometbft'),
        vim.fs.joinpath('~/coding/', 'gaia'),
      }, 'Find Cosmos files'),
      desc = '[S]earch in [C]osmos source (big C)',
    },
    {
      '<leader>sw',
      search_dirs_picker('find_files', {
        vim.fs.joinpath('~/coding/', 'wormhole'),
        vim.fs.joinpath('~/coding/', 'native-token-transfers'),
        vim.fs.joinpath('~/coding/', 'watchdog'),
      }, 'Find Wormhole files'),
      desc = '[S]earch in [w]ormhole source files',
    },
    {
      '<leader>sW',
      search_dirs_picker('find_files', {
        vim.fs.joinpath('~/coding/', 'wormhole'),
        vim.fs.joinpath('~/coding/', 'native-token-transfers'),
        vim.fs.joinpath('~/coding/', 'watchdog'),
      }, 'Find Wormhole files'),
      desc = '[S]earch in [W]ormhole source (big W)',
    },
    {
      '<leader>sp',
      search_dirs_picker('find_files', {
        '~/.config/fabric/patterns/',
        '~/.config/custompatterns/',
      }, 'Search fabric patterns'),
      desc = '[S]earch in [P]atterns (fabric)',
    },
    {
      '<leader>sd',
      function()
        require('telescope.builtin').live_grep {
          search_dirs = go_search_dirs(),
          prompt_title = 'Grep in Go stdlib and packages',
        }
      end,
      desc = '[S]earch Go stan[D]ard lib',
    },
    {
      '<leader>sD',
      function()
        require('telescope.builtin').find_files {
          search_dirs = go_search_dirs(),
          prompt_title = 'Find Go stdlib and package files',
        }
      end,
      desc = '[S]earch Go stan[D]ard lib files (big D)',
    },
  },
  config = function()
    require('telescope').setup {
      defaults = {
        layout_strategy = 'vertical',
        layout_config = {
          vertical = {
            width = function() return vim.o.columns end,
            height = function() return vim.o.lines - 2 end,
            prompt_position = "top"
          }
        },
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
          },
        }
      },
    }

    -- Enable telescope fzf native, if installed
    pcall(require('telescope').load_extension, 'fzf')

    pcall(require('telescope').load_extension, 'harpoon')
  end
}
