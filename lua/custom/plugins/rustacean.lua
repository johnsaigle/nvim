return {
  'mrcjkb/rustaceanvim',
  version = '^6', -- Recommended
  lazy = false,   -- This plugin is already lazy
  config = function()

    vim.g.rustaceanvim = {
      -- Plugin configuration
      tools = {
      },
      -- LSP configuration
      server = {
        on_attach = function(client, bufnr)
          -- you can also put keymaps in here
        end,
        default_settings = {
          -- rust-analyzer language server configuration
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
        },
      },
      -- DAP configuration
      dap = {
      },
    }
  end
}
