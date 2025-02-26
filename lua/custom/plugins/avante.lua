return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  opts = {
    provider = "ollama",
    use_absolute_path = true,
    vendors = {
      ---@type AvanteProvider
      ollama = {
        -- endpoint = "http://nibbler:11434/v1",
        endpoint = "http://localhost:11434/api",
        ask = "",
        api_key_name = "",
        model = "qwen2.5-coder:7b-instruct-q8_0",
        -- Custom curl args parsing for Ollama. https://github.com/yetone/avante.nvim/issues/1067
        parse_curl_args = function(opts, code_opts)
          return {
                url = opts.endpoint .. "/chat",
                headers = {
                    ["Accept"] = "application/json",
                    ["Content-Type"] = "application/json",
                },
                body = {
                    model = opts.model,
                    options = {
                        num_ctx = 16384,
                    },
                    messages = require("avante.providers").copilot.parse_messages(code_opts), -- you can make your own message, but this is very advanced
                    stream = true,
                },
            }
        end,
        -- Custom stream data parsing for Ollama. https://github.com/yetone/avante.nvim/issues/1067
        parse_stream_data = function(data, handler_opts)
            -- Parse the JSON data
            local json_data = vim.fn.json_decode(data)
            -- Check if the response contains a message
            if json_data and json_data.message and json_data.message.content then
                -- Extract the content from the message
                local content = json_data.message.content
                -- Call the handler with the content
                handler_opts.on_chunk(content)
            end
        end,
        -- parse_response_data = function(data_stream, event_state, opts)
        --   require("avante.providers").copilot.parse_response(data_stream, event_state, opts)
        -- end,
      },
    },
    behaviour = {
      auto_suggestions = false, -- Experimental stage
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = true,
    },
    mappings = {
      --- @class AvanteConflictMappings
      diff = {
        ours = 'co',
        theirs = 'ct',
        all_theirs = 'ca',
        both = 'cb',
        cursor = 'cc',
        next = ']x',
        prev = '[x',
      },
      suggestion = {
        accept = '<M-l>',
        next = '<M-]>',
        prev = '<M-[>',
        dismiss = '<C-]>',
      },
      jump = {
        next = ']]',
        prev = '[[',
      },
      submit = {
        normal = '<CR>',
        insert = '<C-s>',
      },
    },
    hints = { enabled = true },
    windows = {
      ---@type "right" | "left" | "top" | "bottom"
      position = 'right',   -- the position of the sidebar
      wrap = true,          -- similar to vim.o.wrap
      width = 30,           -- default % based on available width
      sidebar_header = {
        align = 'center', -- left, center, right for title
        rounded = true,
      },
    },
    highlights = {
      ---@type AvanteConflictHighlights
      diff = {
        current = 'DiffText',
        incoming = 'DiffAdd',
      },
    },
    --- @class AvanteConflictUserConfig
    diff = {
      autojump = true,
      ---@type string | fun(): any
      list_opener = 'copen',
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make BUILD_FROM_SOURCE=true",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
  keys = {
    {
      "<leader>aa",
      function()
        require("avante.api").ask()
      end,
      desc = "avante: ask",
      mode = { "n", "v" },
    },
    {
      "<leader>ac",
      function()
        require("avante.api").ask()
      end,
      desc = "avante: chat",
      mode = { "n", "v" },
    },
    {
      "<leader>ar",
      function()
        require("avante.api").refresh()
      end,
      desc = "avante: refresh",
    },
    {
      "<leader>ae",
      function()
        require("avante.api").edit()
      end,
      desc = "avante: edit",
      mode = "v",
    },
  },
}
