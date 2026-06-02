return {
  'rebelot/kanagawa.nvim',
  opts = {
    theme = 'dragon',
    background = {
      dark = 'dragon',
      light = 'lotus',
    },
  },
  config = function(_, opts)
    require('kanagawa').setup(opts)
    vim.cmd 'colorscheme kanagawa'
  end,
}
