return {
  {
    'anurag3301/nvim-platformio.lua',

    dependencies = {
      'akinsho/toggleterm.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      'nvim-lua/plenary.nvim',
      'folke/which-key.nvim',
      'nvim-treesitter/nvim-treesitter',
    },

    cmd = {
      'Pioinit',
      'Piorun',
      'Piocmdh',
      'Piocmdf',
      'Piolib',
      'Piomon',
      'Piodebug',
      'Piodb',
      'PioLSP',
    },

    config = function()
      vim.g.pioConfig = {
        lsp = 'clangd', -- or "ccls"
        clangd_source = 'compiledb',
        menu_key = '<leader>\\',
        debug = false,
      }

      local ok, platformio = pcall(require, 'platformio')
      if not ok then
        vim.notify('Failed to load PlatformIO plugin', vim.log.levels.ERROR)
        return
      end

      platformio.setup(vim.g.pioConfig)

      -- Get all environments from platformio.ini
      local function get_envs()
        local fname = vim.fn.getcwd() .. '/platformio.ini'
        if vim.fn.filereadable(fname) ~= 1 then return {} end
        local envs = {}
        for _, line in ipairs(vim.fn.readfile(fname)) do
          local env = line:match '%[env:(.+)%]'
          if env then table.insert(envs, env) end
        end
        return envs
      end

      -- Clean unwanted flags from compile_commands.json
      local function clean_compile_commands()
        local fname = vim.fn.getcwd() .. '/compile_commands.json'
        if vim.fn.filereadable(fname) ~= 1 then return end

        local f = io.open(fname, 'r')
        local data = f:read '*a'
        f:close()

        local ok, json = pcall(require, 'dkjson')
        if not ok then return end
        local arr, _, err = json.decode(data)
        if err then
          vim.notify('Failed to parse compile_commands.json: ' .. err, vim.log.levels.ERROR)
          return
        end

        local remove_flags = {
          '-mlongcalls',
          '-mlong-calls',
          '-fstrict-volatile-bitfields',
          '-fno-tree-switch-conversion',
        }

        for _, entry in ipairs(arr) do
          if entry.arguments then
            entry.arguments = vim.tbl_filter(function(a)
              for _, flag in ipairs(remove_flags) do
                if a == flag then return false end
              end
              return true
            end, entry.arguments)
          end
        end

        f = io.open(fname, 'w')
        f:write(json.encode(arr, { indent = true }))
        f:close()
      end

      -- Optional: generate minimal .clangd
      local function generate_clangd_file()
        local f = io.open('.clangd', 'w')
        if not f then return end
        f:write 'CompileFlags:\n'
        f:write '  Remove:\n'
        f:write '    - -mlongcalls\n'
        f:write '    - -mlong-calls\n'
        f:write '    - -fstrict-volatile-bitfields\n'
        f:write '    - -fno-tree-switch-conversion\n'
        f:write 'Diagnostics:\n'
        f:write '  Suppress:\n'
        f:write '    - drv_unknown_argument\n'
        f:write '    - drv_unsupported_opt_for_target\n'
        f:write '    - pp_file_not_found\n'
        f:close()
      end

      -- Generate compile_commands.json for all environments
      local function generate_compiler()
        local envs = get_envs()
        if #envs == 0 then
          vim.notify('No PlatformIO environments found!', vim.log.levels.ERROR)
          return
        end

        for _, env in ipairs(envs) do
          vim.notify('Generating compile_commands.json for env: ' .. env, vim.log.levels.INFO)
          local cmd = { 'pio', 'run', '-e', env, '-t', 'compiledb' }
          vim.fn.system(cmd)
          clean_compile_commands()
        end

        generate_clangd_file()
        vim.cmd 'LspRestart'
      end

      -- Auto-generate compile_commands.json and attach LSP on opening C/C++ files
      vim.api.nvim_create_autocmd('BufReadPost', {
        pattern = { '*.c', '*.cpp', '*.h', '*.hpp' },
        callback = generate_compiler,
      })

      -- Manual fallback command
      vim.api.nvim_create_user_command('PioLSP', generate_compiler, {
        desc = 'Generate compile_commands.json, .clangd, and attach PlatformIO LSP',
      })

      -- Auto-generate immediately if platformio.ini exists
      if vim.fn.filereadable(vim.fn.getcwd() .. '/platformio.ini') == 1 then vim.defer_fn(generate_compiler, 100) end
    end,
  },
}
