return {
  'nvim-telescope/telescope.nvim',
  version = '*',
  dependencies = { 'nvim-lua/plenary.nvim' },
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

    local builtin = require('telescope.builtin')

    vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
    vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- General keymaps
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>st', builtin.git_files, { desc = '[S]earch gi[T] files' })
    vim.keymap.set('n', '<leader>sW', function()
      local word = vim.fn.expand("<cWORD>")
      builtin.grep_string({ search = word })
    end, { desc = '[S]earch current big [W]ord' })

    -- Search ~/audits
    vim.keymap.set('n', '<leader>sa', function()
      local search_dirs = {
        "~/audits",
      }
      builtin.live_grep({
        search_dirs = search_dirs,
        prompt_title = "Search audit notes directory"
      })
    end, { desc = '[S]earch in [A]udit notes' })

    -- Search ~/notes
    vim.keymap.set('n', '<leader>sn', function()
      local search_dirs = {
        "~/notes",
      }
      builtin.live_grep({
        search_dirs = search_dirs,
        prompt_title = "Search notes"
      })
    end, { desc = '[S]earch [N]otes' })

    -- Search Solana and Anchor source files -- Live Grep
    vim.keymap.set('n', '<leader>so', function()
      local search_dirs = {
        -- TODO: Should probably add all of the Solana core repositories now that they're split out of the monorepo
        -- TODO: Add a warning if these paths don't exist.
        vim.fs.joinpath("~/coding/", "agave"),
        vim.fs.joinpath("~/coding/", "anchor"),
        vim.fs.joinpath("~/coding/", "associated-token-account"),
        vim.fs.joinpath("~/coding/", "solana-spl-token"),
        vim.fs.joinpath("~/coding/", "token-2022"),
        vim.fs.joinpath("~/coding/", "sbpf")
      }

      builtin.live_grep({
        search_dirs = search_dirs,
        prompt_title = "Grep in Solana and Anchor files"
      })
    end, { desc = '[S]earch in S[o]lana source lines' })

    -- Search Solana and Anchor source files -- Find Files
    vim.keymap.set('n', '<leader>sO', function()
      local search_dirs = {
        -- TODO: Should probably add all of the Solana core repositories now that they're split out of the monorepo
        -- TODO: Add a warning if these paths don't exist.
        vim.fs.joinpath("~/coding/", "agave"),
        vim.fs.joinpath("~/coding/", "anchor"),
        vim.fs.joinpath("~/coding/", "associated-token-account"),
        vim.fs.joinpath("~/coding/", "solana-spl-token"),
        vim.fs.joinpath("~/coding/", "token-2022"),
        vim.fs.joinpath("~/coding/", "sbpf")
      }

      builtin.find_files({
        search_dirs = search_dirs,
        prompt_title = "Find Solana and Anchor files"
      })
    end, { desc = '[S]earch in S[O]lana source (big O)' })

    -- Search Cosmos-related files -- Live Grep
    vim.keymap.set('n', '<leader>sc', function()
      local search_dirs = {
        -- TODO: Add a warning if these paths don't exist.
        vim.fs.joinpath("~/coding/", "cosmos-sdk"),
        vim.fs.joinpath("~/coding/", "cometbft"),
        vim.fs.joinpath("~/coding/", "gaia"),
      }

      builtin.find_files({
        search_dirs = search_dirs,
        prompt_title = "Find Cosmos files"
      })
    end, { desc = '[S]earch in [C]osmos source files' })

    -- Search Cosmos-related files -- Find Files
    vim.keymap.set('n', '<leader>sC', function()
      local search_dirs = {
        -- TODO: Add a warning if these paths don't exist.
        vim.fs.joinpath("~/coding/", "cosmos-sdk"),
        vim.fs.joinpath("~/coding/", "cometbft"),
        vim.fs.joinpath("~/coding/", "gaia"),
      }

      builtin.find_files({
        search_dirs = search_dirs,
        prompt_title = "Find Cosmos files"
      })
    end, { desc = '[S]earch in [C]osmos source (big C)' })

    -- Search Wormhole-related files -- Live Grep
    vim.keymap.set('n', '<leader>sw', function()
      local search_dirs = {
        -- TODO: Add a warning if these paths don't exist.
        vim.fs.joinpath("~/coding/", "wormhole"),
        vim.fs.joinpath("~/coding/", "native-token-transfers"),
        vim.fs.joinpath("~/coding/", "watchdog"),
      }

      builtin.find_files({
        search_dirs = search_dirs,
        prompt_title = "Find Wormhole files"
      })
    end, { desc = '[S]earch in [w]ormhole source files' })

    -- Search Wormhole-related files -- Find Files
    vim.keymap.set('n', '<leader>sW', function()
      local search_dirs = {
        -- TODO: Add a warning if these paths don't exist.
        vim.fs.joinpath("~/coding/", "wormhole"),
        vim.fs.joinpath("~/coding/", "native-token-transfers"),
        vim.fs.joinpath("~/coding/", "watchdog"),
      }

      builtin.find_files({
        search_dirs = search_dirs,
        prompt_title = "Find Wormhole files"
      })
    end, { desc = '[S]earch in [W]ormhole source (big W)' })

    -- Search fabric prompts
    vim.keymap.set('n', '<leader>sp', function()
      local search_dirs = {
        -- TODO: Add a warning if these paths don't exist.
        "~/.config/fabric/patterns/",
        "~/.config/custompatterns/",
      }

      builtin.find_files({
        search_dirs = search_dirs,
        prompt_title = "Search fabric patterns",
      })
    end, { desc = '[S]earch in [P]atterns (fabric)' })
  end
}
