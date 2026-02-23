return {
  'OXY2DEV/markview.nvim',
  lazy = false,
  opts = {
    preview = {
      enable = true,
      filetypes = { 'markdown', 'codecompanion' },
      ignore_buftypes = {},
    },
  },
  -- Completion for `blink.cmp`
  dependencies = { 'saghen/blink.cmp' },
}
