return {
  'Sengoku11/daml.nvim',
  ft = 'daml',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',           -- syntax highlighting
    'MeanderingProgrammer/render-markdown.nvim', -- pretty script results
  },
  init = function()
    -- daml.nvim configures its own native LSP client, so it bypasses the
    -- global on_attach function in init.lua where the usual LSP mappings live.
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == 'daml' then
          -- DPM advertises semantic tokens but rejects the corresponding LSP
          -- request, so prevent Neovim from sending it after initialization.
          client.server_capabilities.semanticTokensProvider = nil

          local function nmap(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = args.buf, desc = 'LSP: ' .. desc })
          end

          nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
          nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
          nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        end
      end,
    })
  end,
  opts = function()
    if vim.fn.executable('dpm') == 0 then
      vim.notify('daml.nvim: dpm is not executable from Neovim PATH', vim.log.levels.WARN)
    end

    -- Homebrew's JDK is not registered with macOS's /usr/bin/java launcher.
    -- multi-ide starts a Java-backed Script Service, so give its subprocess a
    -- working JDK even when Neovim was started outside a configured shell.
    local java_home = '/opt/homebrew/opt/openjdk'
    if vim.fn.executable(java_home .. '/bin/java') == 1 then
      vim.env.JAVA_HOME = java_home
      if not vim.env.PATH:find(java_home .. '/bin', 1, true) then
        vim.env.PATH = java_home .. '/bin:' .. vim.env.PATH
      end
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    if ok then
      -- Reuse the completion capabilities of the existing nvim-cmp setup;
      -- blink.cmp is deliberately not installed for this plugin.
      capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end

    -- DPM's DAML multi-IDE server does not support semantic tokens.
    capabilities.textDocument.semanticTokens = nil

    return {
      lsp = {
        -- multi-ide enables Daml Script/CodeLens support in addition to the
        -- hover, definition, completion, and diagnostics from `damlc ide`.
        cmd = { 'dpm', 'damlc', 'multi-ide' },
        capabilities = capabilities,
      },
    }
  end,
}
