--[[
  PHP Xdebug configuration for Neovim

  Adds Xdebug debugging support for PHP projects with Homebrew Apache
--]]

return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "php-debug-adapter"
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    config = function()
      local dap = require("dap")
      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { os.getenv("HOME") .. "/.local/share/nvim/mason/packages/php-debug-adapter/extension/out/phpDebug.js" }
      }

      -- Function to dynamically generate path mappings
      local function generate_path_mappings()
        local mappings = {}
        local workspace_folder = vim.fn.getcwd()
        local workspace_basename = vim.fn.fnamemodify(workspace_folder, ":t")

        -- Add the workspace root mapping - this is the most important one
        mappings[workspace_folder] = "${workspaceFolder}"

        -- -- Add Homebrew Apache path - this is needed for local development
        -- local homebrew_path = "/opt/homebrew/var/www/" .. workspace_basename
        -- mappings[homebrew_path] = "${workspaceFolder}"

        return mappings
      end

      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug",
          port = 9003,
          pathMappings = generate_path_mappings()
        },
        -- {
        --   type = "php",
        --   request = "launch",
        --   name = "Launch currently open script",
        --   program = "${file}",
        --   cwd = "${fileDirname}",
        --   port = 0,
        --   runtimeArgs = {
        --     "-dxdebug.start_with_request=yes"
        --   },
        --   env = {
        --     XDEBUG_CONFIG = "client_port=${port}",
        --     XDEBUG_MODE = "debug,develop"
        --   }
        -- }
      }
    end,
  }
}
