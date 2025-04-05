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
      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug",
          port = 9003,
          pathMappings = {
            -- Standard web server paths
            ["/var/www/html"] = "${workspaceFolder}",

            -- Homebrew Apache paths
            ["/opt/homebrew/var/www/${workspaceFolderBasename}"] = "${workspaceFolder}",

            -- WordPress core with theme in subdirectory
            ["/opt/homebrew/var/www/${workspaceFolderBasename}/wordpress/wp-content/themes/${workspaceFolderBasename}"] = "${workspaceFolder}/wp-content/themes/${workspaceFolderBasename}",
            ["/opt/homebrew/var/www/${workspaceFolderBasename}/wordpress/wp-content/themes/theme"] = "${workspaceFolder}/theme",

            -- WordPress with theme at project root
            ["/opt/homebrew/var/www/${workspaceFolderBasename}/wp-content/themes/${workspaceFolderBasename}"] = "${workspaceFolder}/wp-content/themes/${workspaceFolderBasename}",

            -- When working directly in theme directory
            ["/opt/homebrew/var/www/${workspaceFolderBasename}/wordpress/wp-content/themes/${workspaceFolderBasename}"] = "${workspaceFolder}",
            ["/opt/homebrew/var/www/${workspaceFolderBasename}/wp-content/themes/${workspaceFolderBasename}"] = "${workspaceFolder}",

            -- Flynt-specific structure
            ["/opt/homebrew/var/www/${workspaceFolderBasename}/theme"] = "${workspaceFolder}/theme",

            -- Common plugin paths
            ["/opt/homebrew/var/www/${workspaceFolderBasename}/wordpress/wp-content/plugins"] = "${workspaceFolder}/wp-content/plugins",
            ["/opt/homebrew/var/www/${workspaceFolderBasename}/wp-content/plugins"] = "${workspaceFolder}/wp-content/plugins"
          }
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
