-- TODO Finish this task
-- TODO include this file in `init.lua`
-- --> Add a 'cite' command that:
--     - looks at highlighted lines
--     - grabs line numbers
--     - grabs current git commit hash and remote/URL
--     - makes a citation that can be pasted into GitHub:
--         https://github.com/org/repo/blob/<COMMIT>/filpath#L29-L30
--
-- ### Also add it in neovim
--
-- Get beginning and end line number of a highlighted section
--
-- Get current file, probably something like:
--
-- ```lua
-- local file = vim.fn.expand('%') 
-- ```
--
-- Combine with absolute path to current working directory:
-- ```lua
-- local cwd = vim.fn.expand('%:p') 
-- ```
--
-- Get the git root of the project (with bash? or is there another way?)
--
-- This command can be used to get the root directory
-- ```sh
-- git rev-parse --show-toplevel
-- ```
-- Use these pieces to form the path from the git repo.
-- - Remove everything but the last folder from the git toplevel command (split on `/` and take the last element)
-- - Find index of the last element in the `cwd` for neovim and remove everything that comes before
-- - Then append the current file to the `cwd`

-- git rev-parse --show-toplevel
local toplevel = vim.fn.system {
  'git',
  'rev-parse',
  '--show-toplevel'
}
local cwd = vim.fn.getcwd()
local file = vim.fn.expand('%')
-- Get URL from remote, in bash. This is assuming an SSH-based remote
-- REPO=$(git remote get-url origin | cut -d ':' -f 2 | cut -d '.' -f 1)
-- Or `:Git config --get remote.origin.url` for the neovim command area

