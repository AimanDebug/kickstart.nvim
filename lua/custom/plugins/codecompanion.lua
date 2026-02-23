return {
  'olimorris/codecompanion.nvim',
  version = '^18.0.0',
  opts = {},
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'OXY2DEV/markview.nvim',
  },
  lazy = false,
  keys = {
    {
      '<C-a>',
      '<cmd>CodeCompanionActions<cr>',
      mode = { 'n', 'v' },
      desc = 'Trigger Code Companion Actions',
    },
    {
      '<LocalLeader>a',
      '<cmd>CodeCompanionChat Toggle<cr>',
      mode = { 'n', 'v' },
      desc = 'Toggle Code Companion Chat',
    },
    {
      'ga',
      '<cmd>CodeCompanionChat Add<cr>',
      mode = 'v',
      desc = 'Add selection to Code Companion Chat',
    },
  },
  init = function() vim.cmd [[cab cc CodeCompanion]] end,
}
