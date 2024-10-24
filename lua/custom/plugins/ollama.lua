return {
  "nomnivore/ollama.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
  },

  -- All the user commands added by the plugin
  cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },

  keys = {
    -- Sample keybind for prompt menu. Note that the <c-u> is important for selections to work properly.
    {
      "<leader>oo",
      ":<c-u>lua require('ollama').prompt()<cr>",
      desc = "ollama prompt",
      mode = { "n", "v" },
    },

    -- Sample keybind for direct prompting. Note that the <c-u> is important for selections to work properly.
    {
      "<leader>oG",
      ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
      desc = "ollama Generate Code",
      mode = { "n", "v" },
    },
  },

  ---@type Ollama.Config
  opts = {
    -- your configuration overrides
    model = "llama3.2",
    url = "http://127.0.0.1:11434",
    serve = {
      on_start = false,
      command = "ollama",
      args = { "serve" },
      stop_command = "pkill",
      stop_args = { "-SIGTERM", "ollama" },
    },
    -- View the actual default prompts in ./lua/ollama/prompts.lua
    prompts = {
      Summarize_Text = {
        prompt = "Please summarize this text. Additional instructions: $input. Here is the text: $sel.",
        input_label = "> ",
        model = "llama3.2",
        action = "display",
      },
      Summarize_Lint = {
        prompt = "This text is the output of a code linter. Summarize the results into a general overview, grouped by issue type. Avoid chatter. Do not include any code in your response. Do not make suggestions or changes. Do not add code snippets. Here is the output of the linter: ```$sel```. ",
        input_label = "> ",
        model = "llama3.2",
        action = "display",
      },
      Document_Block = {
        prompt = "This $ftype code block needs better documentation. Summarize the code concisely at a high-level. Format your response in the correct commenting convention for the programming language. Make sure to document security-related functionality. Avoid chatter. Do not include the source code in your response. Do not summarize the work you have done. Group your comments together so that can be added to the top of the code block. Here is the code that needs commenting: $sel.",
        input_label = "> ",
        model = "llama3.2",
        action = "display",
      },
    }
    -- View the actual default prompts in ./lua/ollama/prompts.lua
    -- prompts = {
    --   Sample_Prompt = {
    --     prompt = "This is a sample prompt that receives $input and $sel(ection), among others.",
    --     input_label = "> ",
    --     model = "mistral-nemo",
    --     action = "display",
    --   }
    -- }
  }
}
