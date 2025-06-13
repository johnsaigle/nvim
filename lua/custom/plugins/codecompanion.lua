# Cheatsheet for keymaps: https://codecompanion.olimorris.dev/usage/chat-buffer/#keymaps
return {
  "olimorris/codecompanion.nvim",
  opts = {},
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    ---Read API key from file
    ---@param filepath string Path to the API key file
    ---@return string api_key The trimmed API key
    local function read_api_key(filepath)
      ---@type file*?
      local file, err = io.open(filepath, "r")
      if not file then
        vim.notify("Could not open API key file: " .. filepath .. ". Error: " .. (err or "Unknown error"), vim.log.levels.WARN)
        return ""
      end

      ---@type string?
      local content = file:read("*all")
      file:close()

      if not content or content == "" then
        vim.notify("API key file is empty: " .. filepath, vim.log.levels.WARN)
        return ""
      end

      -- Trim whitespace from both ends
      ---@type string
      local api_key = content:match("^%s*(.-)%s*$") or ""

      return api_key
    end

    -- Use local LLMs by default.
    require("codecompanion").setup({
      strategies = {
        cmd = {
          adapter = "qwen_coder",
        },
        chat = {
          adapter = "qwen_coder",
          -- adapter = "gemini",
        },
        inline = {
          adapter = "qwen_coder",
        },
        workflow = {
          adapter = "qwen_coder",
        },
      },
      adapters = {
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            env = {
              api_key = read_api_key(os.getenv("HOME") .. "/.config/codecompanion/api-keys/anthropic")
            }
          })
        end,
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            env = {
              api_key = read_api_key(os.getenv("HOME") .. "/.config/codecompanion/api-keys/gemini")
            },
          })
        end,
        llama3 = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "llama3", -- Give this adapter a different name to differentiate it from the default ollama adapter
            schema = {
              model = {
                default = "llama3.2:latest",
              },
            },
          })
        end,
        gemma3_4b = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "gemma3_4b", -- Give this adapter a different name to differentiate it from the default ollama adapter
            schema = {
              model = {
                default = "gemma3:4b",
              },
            },
          })
        end,
        gemma3_qat = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "gemma3_qat", -- Give this adapter a different name to differentiate it from the default ollama adapter
            schema = {
              model = {
                default = "gemma3:12b-it-qat",
              },
            },
          })
        end,
        qwen3 = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "qwen3", -- Give this adapter a different name to differentiate it from the default ollama adapter
            schema = {
              model = {
                default = "qwen3:latest",
              },
              -- num_ctx = {
              --   default = 4096
              -- },
            },
          })
        end,
        qwen_coder = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "qwen_coder", -- Give this adapter a different name to differentiate it from the default ollama adapter
            schema = {
              model = {
                default = "qwen2.5-coder:3b",
              },
              -- num_ctx = {
              --   default = 4096
              -- },
            },
          })
        end,
      },

    })
  end,
}
