local function open_nvim_tree(data)
  local is_directory = vim.fn.isdirectory(data.file) == 1

  if not is_directory then
    local is_real_file = vim.fn.filereadable(data.file) == 1
    local is_unnamed = data.file == "" and vim.bo[data.buf].buftype == ""

    if not is_real_file and not is_unnamed then
      return
    end

    -- open the tree, find the file but don't focus it
    require("nvim-tree.api").tree.toggle({ focus = false, find_file = true, })
    return
  end

  vim.cmd.cd(data.file)
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
