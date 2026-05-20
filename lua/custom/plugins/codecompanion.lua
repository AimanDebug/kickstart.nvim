return {
  'olimorris/codecompanion.nvim',
  version = '^19.0.0',
  opts = {
    adapters = {
      acp = {
        gemini_cli = function()
          return require('codecompanion.adapters').extend('gemini_cli', {
            defaults = {
              auth_method = 'oauth-personal', -- "oauth-personal"|"gemini-api-key"|"vertex-ai"
            },
          })
        end,
      },
    },
    interactions = {
      chat = {
        adapter = 'gemini_cli',
      },
      cli = {
        agent = 'gemini_cli',
        agents = {
          gemini_cli = {
            cmd = 'gemini',
            args = {},
            description = 'Gemini CLI',
            provider = 'terminal',
          },
          copilot_cli = {
            cmd = 'copilot',
            args = {},
            description = 'Copilot CLI',
            provider = 'terminal',
          },
        },
      },
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'OXY2DEV/markview.nvim',
  },
  keys = {
    {
      '<leader>a',
      '<cmd>CodeCompanionActions<cr>',
      desc = 'Code Companion Actions',
    },
    {
      '<leader>c',
      '<cmd>CodeCompanionChat Toggle<cr>',
      desc = 'Toggle Code Companion Chat',
    },
    {
      '<leader>k',
      '<cmd>CodeCompanionCLI<cr>',
      desc = 'Code Companion CLI',
    },
  },
  lazy = false,
}
