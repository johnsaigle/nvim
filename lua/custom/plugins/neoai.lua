return {
    "johnsaigle/neoai.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    cmd = {
        "NeoAIOpen",
        "NeoAI",
        "NeoAIClose",
        "NeoAIToggle",
        "NeoAIContext",
        "NeoAIContextOpen",
        "NeoAIContextClose",
        "NeoAIInject",
        "NeoAIInjectCode",
        "NeoAIInjectContext",
        "NeoAIInjectContextCode",
    },
    keys = {
        { "<leader>ns", desc = "summarize text" },
        { "<leader>ng", desc = "generate git message" },
    },
    config = function()
        require("neoai").setup({
            -- Below are the default options, feel free to override what you would like changed
            ui = {
                output_popup_text = "NeoAI",
                input_popup_text = "Prompt",
                width = 35, -- As percentage eg. 30%
                output_popup_height = 80, -- As percentage eg. 80%
                submit = "<Enter>", -- Key binding to submit the prompt
            },
            models = {
                {
                    name = "janai",
                    model = "llama3-8b-instruct", -- update to whatever is installed in JanAI
                    params = nil,
                },
                -- Original upstream settings
                -- {
                --     name = "openai",
                --     model = "gpt-3.5-turbo",
                --     params = nil,
                -- },
            },
            register_output = {
                ["g"] = function(output)
                    return output
                end,
                ["c"] = require("neoai.utils").extract_code_snippets,
            },
            inject = {
                cutoff_width = 75,
            },
            prompts = {
                context_prompt = function(context)
                    return "Hey, I'd like to provide some context for future "
                        .. "messages. Here is the code/text that I want to refer "
                        .. "to in our upcoming conversations:\n\n"
                        .. context
                end,
            },
            mappings = {
                ["select_up"] = "<C-k>",
                ["select_down"] = "<C-j>",
            },
            shortcuts = {
                {
                    name = "textify",
                    key = "<leader>ns",
                    desc = "fix text with AI",
                    use_context = true,
                    prompt = [[
                Please rewrite the text to make it more readable, clear,
                concise, and fix any grammatical, punctuation, or spelling
                errors
            ]],
                    modes = { "v" },
                    strip_function = nil,
                },
                {
                    name = "gitcommit",
                    key = "<leader>ng",
                    desc = "generate git commit message",
                    use_context = false,
                    prompt = function()
                        return [[
                    Using the following git diff generate a concise and
                    clear git commit message, with a short title summary
                    that is 75 characters or less:
                ]] .. vim.fn.system("git diff --cached")
                    end,
                    modes = { "n" },
                    strip_function = nil,
                },
            },
        })
    end,
}
