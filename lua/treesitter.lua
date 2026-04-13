
-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'bash', 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'solidity', 'tsx', 'typescript', 'vim' },

  auto_install = true,

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Work around nvim-treesitter#8636 on Neovim 0.12.
-- The markdown `#set-lang-from-info-string!` directive can receive a capture shape
-- that `vim.treesitter.get_node_text()` cannot read, which blows up during hover-doc
-- markdown parsing. Override just that directive so normal injections still work and
-- the bad capture is skipped instead of crashing the highlighter.
do
  require('nvim-treesitter.query_predicates')

  local query = require 'vim.treesitter.query'
  local info_string_aliases = {
    ex = 'elixir',
    pl = 'perl',
    sh = 'bash',
    ts = 'typescript',
    uxn = 'uxntal',
  }

  local function parser_from_info_string(alias)
    local match = vim.filetype.match { filename = 'a.' .. alias }
    return match or info_string_aliases[alias] or alias
  end

  query.add_directive('set-lang-from-info-string!', function(match, _, bufnr, pred, metadata)
    local node = match[pred[2]]
    if not node then
      return
    end

    local ok, text = pcall(vim.treesitter.get_node_text, node, bufnr)
    if not ok or type(text) ~= 'string' or text == '' then
      return
    end

    metadata['injection.language'] = parser_from_info_string(text:lower())
  end, { force = true, all = false })
end
