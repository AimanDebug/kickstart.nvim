return {
  'nvim-tree/nvim-tree.lua',
  version = '^1.3',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    on_attach = function(bufnr)
      local api = require 'nvim-tree.api'
      local function opts(desc) return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true } end

      api.map.on_attach.default(bufnr)

      vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts 'Up')
      vim.keymap.set('n', '?', api.tree.toggle_help, opts 'Help')
    end,
  },
  init = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
  keys = {
    { '<leader>fe', '<cmd>NvimTreeToggle<cr>', desc = 'Toggle File Explorer' },
    { '<leader>f/', '<cmd>NvimTreeFindFile<cr>', desc = 'Find File in Explorer' },
  },
}
