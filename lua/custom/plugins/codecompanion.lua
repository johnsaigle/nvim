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
        vim.notify("Could not open API key file: " .. filepath .. ". Error: " .. (err or "Unknown error"),
          vim.log.levels.WARN)
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

    -- Fabric pattern loader functions
    local fabric_dir = vim.fn.expand("~/.config/fabric/patterns")

    -- Helper function to check if a file exists
    local function file_exists(path)
      local stat = vim.loop.fs_stat(path)
      return stat and stat.type == "file"
    end

    -- Helper function to read file contents
    local function read_file(path)
      local file = io.open(path, "r")
      if not file then
        return nil
      end
      local content = file:read("*all")
      file:close()
      return content
    end

    -- Helper function to scan directory for pattern folders
    local function scan_patterns_dir(dir)
      local handle = vim.loop.fs_scandir(dir)
      if not handle then
        return {}
      end

      local patterns = {}
      while true do
        local name, type = vim.loop.fs_scandir_next(handle)
        if not name then break end

        if type == "directory" then
          local system_file = dir .. "/" .. name .. "/system.md"
          if file_exists(system_file) then
            table.insert(patterns, {
              name = name,
              path = system_file
            })
          end
        end
      end

      return patterns
    end

    -- Convert fabric pattern name to a more readable format
    local function format_pattern_name(name)
      local formatted = name:gsub("[_-]", " ")
      formatted = formatted:gsub("(%l)(%w*)", function(a, b)
        return string.upper(a) .. b
      end)
      return formatted
    end

    -- Create a short name for slash commands
    local function create_short_name(name)
      return name:gsub("[^%w]", ""):lower()
    end

    -- Load fabric patterns and return them as CodeCompanion prompts
    local function load_fabric_patterns()
      -- Check if fabric patterns directory exists
      local stat = vim.loop.fs_stat(fabric_dir)
      if not stat or stat.type ~= "directory" then
        vim.notify("Fabric patterns directory not found: " .. fabric_dir, vim.log.levels.WARN)
        return {}
      end

      local patterns = scan_patterns_dir(fabric_dir)
      local prompt_library = {}

      for _, pattern in ipairs(patterns) do
        local system_content = read_file(pattern.path)
        if system_content then
          -- Clean up the system content
          system_content = system_content:gsub("^%s+", ""):gsub("%s+$", "")

          local formatted_name = format_pattern_name(pattern.name)
          local short_name = create_short_name(pattern.name)

          -- Create the prompt entry for CodeCompanion
          prompt_library["Fabric: " .. formatted_name] = {
            strategy = "chat",
            description = "Fabric pattern: " .. pattern.name,
            opts = {
              short_name = short_name,
              is_slash_cmd = true,
              auto_submit = false,
              user_prompt = true,
            },
            prompts = {
              {
                role = "system",
                content = system_content,
              },
              {
                role = "user",
                content = function(context)
                  -- If text is selected, include it in the prompt
                  if context.is_visual then
                    local text = require("codecompanion.helpers.actions").get_code(
                      context.start_line,
                      context.end_line
                    )
                    return "Here's the content I'd like you to analyze:\n\n```" ..
                        context.filetype .. "\n" .. text .. "\n```"
                  else
                    return "<user_prompt>Please provide your input:</user_prompt>"
                  end
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          }
        end
      end

      return prompt_library
    end

    -- Load fabric patterns
    local fabric_prompts = load_fabric_patterns()

    if vim.tbl_count(fabric_prompts) > 0 then
      vim.notify("Loaded " .. vim.tbl_count(fabric_prompts) .. " fabric patterns into CodeCompanion", vim.log.levels
      .INFO)
    end

    -- Use local LLMs by default.
    require("codecompanion").setup({

      prompt_library = vim.tbl_extend("force", {}, fabric_prompts),

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
