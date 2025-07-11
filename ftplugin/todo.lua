-- ~/.config/nvim/plugin/todo.lua
-- Auto-loaded on startup because it lives in the plugin/ directory.
-- Provides:
--   • iabbrev /t   → “# Thursday, Jul 10th, 2025”  (adjusts daily)
--   • iabbrev ---  → 85 em-dashes
--   • Normal-mode mappings:
--       cw  → mark line as “w ” (working)
--       cb  → mark line as “b ” (blocked)
--       ct  → mark line as “t ” (todo)
--
--   Change the keymaps below if you’d rather not override Vim’s built-in
--   change-motion commands.

local M = {}

----------------------------------------------------------------------
-- Date helpers -------------------------------------------------------
----------------------------------------------------------------------

---Return a header like "# Thursday, Jul 10th, 2025".
function M.today_header()
  local d = tonumber(os.date('%d'))           -- day of month
  -- Choose ordinal suffix -------------------------------------------
  local suf
  local last2 = d % 100
  if last2 >= 11 and last2 <= 13 then
    suf = 'th'
  else
    local last = d % 10
    suf = (last == 1 and 'st')
       or (last == 2 and 'nd')
       or (last == 3 and 'rd')
       or 'th'
  end
  return ('# %s%d%s, %s'):format(os.date('%A, %b '), d, suf, os.date('%Y'))
end

---Return a line of 85 em-dashes (matches your VimScript length).
function M.day_separator()
  return string.rep('—', 85)
end

----------------------------------------------------------------------
-- Status setter ------------------------------------------------------
----------------------------------------------------------------------

---Add or replace a status marker ('w', 'b', or 't') at the *start*
---of the **current** line, preserving indent and original spacing.
---@param status string  -- 'w' | 'b' | 't'
function M.set_status(status)
  if not status:match('^[wbtdm]$') then return end

  local lnum   = vim.api.nvim_win_get_cursor(0)[1]   -- current line number
  local line   = vim.api.nvim_get_current_line()

  --------------------------------------------------------------------
  -- 1. Separate leading indent from the rest of the content ---------
  --------------------------------------------------------------------
  local indent, content = line:match('^(%s*)(.*)$')

  --------------------------------------------------------------------
  -- 2. Detect & strip existing marker, capture its whitespace -------
  --------------------------------------------------------------------
  local sep   -- whitespace that should follow the new marker
  local rest  -- text after any existing marker/whitespace

  do
    local old_marker, old_sep, tail = content:match('^([wbtdm])(%s+)(.*)$')
    if old_marker then
      sep  = old_sep      -- keep same spacing (tabs/spaces) as before
      rest = tail
    else
      sep  = '\t'         -- default separator first time we add a marker
      rest = content
    end
  end

  --------------------------------------------------------------------
  -- 3. Assemble new line -------------------------------------------
  --------------------------------------------------------------------
  local new_line = indent .. status .. sep .. rest
  vim.api.nvim_set_current_line(new_line)

  -- Keep cursor on status column (optional nicety)
  vim.api.nvim_win_set_cursor(0, { lnum, #indent })

  vim.cmd('silent! write')
end

----------------------------------------------------------------------
-- Expose module so v:lua.require'todo' works -------------------------
----------------------------------------------------------------------
package.loaded['todo'] = M

----------------------------------------------------------------------
-- Insert-mode abbreviations -----------------------------------------
----------------------------------------------------------------------
vim.cmd([[
  iabbrev <expr> /t  v:lua.require'todo'.today_header()
  iabbrev <expr> --- v:lua.require'todo'.day_separator()
]])

----------------------------------------------------------------------
-- Normal-mode keymaps ------------------------------------------------
-- Comment these out or change them if you’d rather keep default `cw`.
----------------------------------------------------------------------
local map  = vim.keymap.set
local opts = { noremap = true, silent = true, desc = 'Todo status' }

map('n', 'mw', function() require('todo').set_status('w') end, opts)
map('n', 'mb', function() require('todo').set_status('b') end, opts)
map('n', 'mt', function() require('todo').set_status('t') end, opts)
map('n', 'md', function() require('todo').set_status('d') end, opts)
map('n', 'mm', function() require('todo').set_status('m') end, opts)

vim.cmd([[
  setlocal nonumber norelativenumber
]])

return M
