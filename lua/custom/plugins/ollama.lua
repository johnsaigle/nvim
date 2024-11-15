local response_format = "Respond EXACTLY in this format:\n```$ftype\n<your comments>\n```"
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
      -- Ourobouros 
      Detect_LLM = {
        prompt = "Do you think the following text was written by an LLM? If so, explain why. Here is the text: $sel",
        input_label = "> ",
        model = "llama3.2",
        action = "display",
      },
      Document_Block = {
        prompt = [[
Generate documentation comments for this $ftype code block.
Return ONLY the documentation comments in the correct comment syntax for $ftype.
Place all comments at the top of the code block.

Focus on:
- High-level code summary
- Security-relevant functionality
- Do not include the original code
- No explanatory text, just the comments

Code to document:
===CODE
$sel
===END CODE

```$$ftype\n<your comments>\n```
        ]],
        model = "llama3.2",
        action = "replace",
      },
      Summarize_Commits = {
        prompt = "The following text contains a series of git commit messages. Summarize the text as a concise project update. Avoid commentary. Here is the text: $sel",
        input_label = "> ",
        model = "llama3.2",
        action = "display",
      },
      Formalize_Scratch_Notes = {
        prompt = [[
Convert informal notes into a well-structured document by:

1. Organize content into these sections:
   - Summary (2-3 sentences overview)
   - Action Items (as bullet points)  
   - Questions (each on new line, prefixed with "Q:")
   - Details (formatted as complete sentences, grouped by topic)

2. Apply these formatting rules:
   - URLs: [summary](url)
   - Code/technical terms: `backticks`
   - Important terms: **bold**
   - Lists: indented with bullet points
   - Limit line length to 80 characters
   - Use proper punctuation and capitalization

3. Improve clarity:
   - Expand abbreviations 
   - Remove redundancies
   - Convert fragments into complete sentences
   - Preserve any specific numbers, dates, or technical details

===INPUT NOTES===
$sel
===OUTPUT===

Organize the content using markdown formatting.
        ]],
        input_label = "> ",
        model = "llama3.2",
        action = "display",
      },
      Summarize_Lint = {
        prompt = [[
This text is the output of a code linter. 
Summarize the results into a general overview, grouped by issue type. Avoid chatter. 
Focus on the linter output instead of code snippets. 

Here is the output of the linter: 
===BEGIN LINTER RESULTS===
$sel
===END LINTER RESULTS===
        ]],
        input_label = "> ",
        model = "llama3.2",
        action = "display",
      },
      Summarize_Text = {
        prompt = [[
Please summarize this text. Additional instructions: $input. Here is the text: $sel.
            ]],
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
