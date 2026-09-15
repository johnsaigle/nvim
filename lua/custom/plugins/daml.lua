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

           -- damlc ide returns declaration docs, but currently omits field-level
           -- Haddock comments (`-- ^`) from hover results.
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

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    if ok then
      -- Reuse the completion capabilities of the existing nvim-cmp setup;
      -- blink.cmp is deliberately not installed for this plugin.
      capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end

    -- DPM's DAML multi-IDE server does not support semantic tokens.
    capabilities.textDocument.semanticTokens = nil

    local cmd = { 'dpm', 'damlc', 'ide', '--scripts', 'no' }

    return {
      lsp = {
        -- damlc resolves daml.yaml and its generated package database relative
        -- to its process cwd. daml.nvim sets root_dir but does not set cmd_cwd,
        -- so launching Neovim elsewhere can make damlc fall back to LF 2.2 and
        -- look for a nonexistent .daml/package-database/2.2. Start one client
        -- per nearest daml.yaml and explicitly run it from that package root.
        -- Do not add multi-package.yaml here: its parent directory has no
        -- package database of its own, and its packages may target different
        -- LF versions or maintain separate generated dependencies.
        root_markers = { 'daml.yaml' },
        -- The DPM SDK 3.5.1 artifact repeatedly installs a truncated
        -- script-service.jar, causing both `multi-ide` and the default `ide`
        -- mode to exit before LSP navigation becomes available. Disable only
        -- Daml Script execution/CodeLens; definitions, hover, completion, and
        -- diagnostics continue to work. This flag can be removed after the
        -- project SDK is upgraded and its script-service.jar passes `jar tf`.
        cmd = function(dispatchers, config)
          -- A function command is required because cmd_cwd is package-specific;
          -- daml.nvim currently forwards cmd but not cmd_cwd to Neovim's client.
          return vim.lsp.rpc.start(cmd, dispatchers, {
            cwd = config.root_dir,
            env = config.cmd_env,
            detached = config.detached,
          })
        end,
        capabilities = capabilities,
      },
    }
  end,
}
