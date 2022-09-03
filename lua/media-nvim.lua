local M = {}

local default_filetypes = { 'png', 'jpg', 'gif', 'mp4', 'webm', 'pdf' }

--- @class config
--- @field filetypes string[] | nil
--- @field script_path string | nil

--- @param config config | nil
M.setup = function(config)
  config = config or {}

  if config.script_path then
    M.script_path = config.script_path
  else
    local sourced_path = debug.getinfo(1).source:sub(2)
    local basedir = vim.fn.fnamemodify(sourced_path, ':h:h')
    M.script_path = basedir .. '/scripts/render'
  end

  M.filetypes = config.filetypes or default_filetypes
  local ft_pattern = '*.' .. table.concat(M.filetypes, ',*.')

  M.augroup = vim.api.nvim_create_augroup('MediaNvim', {})

  vim.api.nvim_create_autocmd('BufReadCmd', {
    group = M.augroup,
    pattern = ft_pattern,
    callback = function(args)
      local buf = args.buf
      vim.api.nvim_buf_set_option(buf, 'modifiable', false)
      M.show()
    end,
  })

  vim.api.nvim_create_autocmd('WinEnter', {
    group = M.augroup,
    pattern = ft_pattern,
    callback = function()
      M.show()
    end,
  })

  vim.api.nvim_create_autocmd({ 'WinScrolled', 'VimResized' }, {
    group = M.augroup,
    callback = function()
      M.show()
      -- M.redraw()
    end,
  })

  vim.api.nvim_create_autocmd('BufLeave', {
    group = M.augroup,
    pattern = ft_pattern,
    callback = function()
      M.hide()
    end,
  })

  vim.api.nvim_create_autocmd('ExitPre', {
    group = M.augroup,
    callback = function()
      M.hide()
    end,
  })
end

--- @param win window #window id
--- @return number, number, number, number #x, y, width, height
local get_win_dimensions = function(win)
  local info = vim.fn.getwininfo(win)[1]
  return info.wincol - 1, info.winrow + info.winbar - 1, info.width, info.height
end

--- @param win window | nil #window id, nil for current window
local get_cmd = function(win)
  win = win or vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)
  ---@diagnostic disable-next-line: missing-parameter
  local file = vim.api.nvim_buf_get_name(buf) ---@type string
  local x, y, width, height = get_win_dimensions(win)
  return M.script_path, {
    file,
    x,
    y,
    width,
    height,
  }
end

M.show = function()
  M.hide()
  local cmd, args = get_cmd()
  M.proc = vim.loop.spawn(cmd, {
    args = args,
    stdio = {},
  })
end

M.hide = function()
  if M.proc then
    M.proc:kill()
    M.proc = nil
  end
end

return M
