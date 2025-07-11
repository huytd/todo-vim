-- plugin/todo.lua
-- File-type detection for "*.todo" and exact "Inbox.txt"

-- Modern API: vim.filetype.add (Neovim ≥0.10) ------------------------------
pcall(vim.filetype.add, {
  extension = { todo = "todo" },
  filename  = { ["Inbox.txt"] = "todo" },
})

-- Fallback for older Neovim -------------------------------------------------
-- (Remove this whole block if you only target 0.10+)
if vim.fn.has("nvim-0.9") == 1 then
  local aug = vim.api.nvim_create_augroup("todo_ftdetect", { clear = true })
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = aug,
    pattern = { "*.todo", "Inbox.txt" },
    callback = function() vim.bo.filetype = "todo" end,
  })
end

---------------------------------------------------------------------------
-- Optional: expose a setup() so users can tweak behaviour
local M = {}

function M.setup(opts)
  opts = opts or {}
  -- e.g. let users supply extra patterns
  if opts.extra_patterns then
    for _, pat in ipairs(opts.extra_patterns) do
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        group = "todo_ftdetect",
        pattern = pat,
        callback = function() vim.bo.filetype = "todo" end,
      })
    end
  end
end

return M
