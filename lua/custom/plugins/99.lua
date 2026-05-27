return {
  'ThePrimeagen/99',
  event = 'VeryLazy',
  dir = "~/coding/99", -- my fork
  config = function()
    local _99 = require '99'

    local cwd = vim.uv.cwd() or vim.fn.getcwd()
    local basename = vim.fs.basename(cwd)
    local git_root = vim.fs.root(cwd, '.git')

    if git_root and vim.fs.normalize(git_root) ~= vim.fs.normalize(cwd) then
      vim.notify(
        '99: cwd is not repo root; run :cd ' .. git_root .. ' for more reliable OpenCode behavior',
        vim.log.levels.WARN
      )
    end

    _99.setup {
      -- Default provider is OpenCodeProvider (calls `opencode`).
       -- provider = _99.Providers.ClaudeCodeProvider,

       -- model = "openai/gpt-5.2",
       model = "opencode-go/deepseek-v4-pro",

      -- Keep tmp inside project cwd to avoid external-dir permission issues.
      tmp_dir = './tmp',

      -- Enable #rules and @files completion via nvim-cmp.
      completion = {
        source = 'cmp',
        -- custom_rules = { 'scratch/custom_rules/' },
        files = { exclude = { '.git', 'node_modules', '*.proto' } },
      },




      -- Auto-attach project-level instructions.
      md_files = { 'AGENT.md' },

      logger = {
        level = _99.DEBUG,
        path = '/tmp/' .. basename .. '.99.debug',
        print_on_error = true,
      },
    }

    -- Visual replace (requires an active visual selection)
    vim.keymap.set('v', '<leader>9v', function()
      _99.visual()
    end, { desc = '99: visual replace' })

    -- Project search -> quickfix
    vim.keymap.set('n', '<leader>9s', function()
      _99.search()
    end, { desc = '99: search (qf)' })

    -- Open last interaction
    vim.keymap.set('n', '<leader>9o', function()
      _99.open()
    end, { desc = '99: open last result' })

    -- Cancel in-flight requests
    vim.keymap.set('n', '<leader>9x', function()
      _99.stop_all_requests()
    end, { desc = '99: stop all requests' })

    -- View logs for the last run
    vim.keymap.set('n', '<leader>9l', function()
      _99.view_logs()
    end, { desc = '99: view logs' })

    -- Optional: model/provider pickers (requires telescope)
    vim.keymap.set('n', '<leader>9m', function()
      local ok = pcall(function()
        require('99.extensions.telescope').select_model()
      end)
      if not ok then
        vim.notify('99: telescope extension not available', vim.log.levels.WARN)
      end
    end, { desc = '99: select model (telescope)' })

    vim.keymap.set('n', '<leader>9p', function()
      local ok = pcall(function()
        require('99.extensions.telescope').select_provider()
      end)
      if not ok then
        vim.notify('99: telescope extension not available', vim.log.levels.WARN)
      end
    end, { desc = '99: select provider (telescope)' })
  end,
}
