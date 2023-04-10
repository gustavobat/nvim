local colorschemes = { 'terafox', 'kanagawa', 'nord', }

for _, colorscheme in ipairs(colorschemes) do
  local status_ok, _ = pcall(vim.cmd, 'colorscheme ' .. colorscheme)
  if status_ok then
    return
  else
    vim.notify('Colorscheme ' .. colorscheme .. ' not found.')
  end
end

