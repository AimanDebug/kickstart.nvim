return {
  'brenoprata10/nvim-highlight-colors',
  config = function()
    -- Ensure termguicolors is enabled
    vim.opt.termguicolors = true
    require('nvim-highlight-colors').setup {}
  end,
}
