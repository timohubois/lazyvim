--[[
  Stylelint support for Neovim

  Provides CSS/SCSS linting and formatting via Stylelint LSP.

  Features:
  - LSP-based linting and formatting
  - Project-specific config detection
  - Format on save support
  - Manual formatting via <leader>cf

  See: https://github.com/bmatcuk/stylelint-lsp
--]]

return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "bmatcuk/stylelint-lsp",
    },
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.stylelint_lsp = {
        settings = {
          stylelintplus = {
            autoFixOnFormat = true,
            autoFixOnSave = true,
            validateOnSave = true,
          },
        },
        root_dir = require("lspconfig.util").root_pattern(
          ".stylelintrc",
          ".stylelintrc.cjs",
          ".stylelintrc.js",
          ".stylelintrc.json",
          ".stylelintrc.yaml",
          ".stylelintrc.yml",
          "stylelint.config.cjs",
          "stylelint.config.js",
          "package.json"
        ),
      }
    end
  }
}
