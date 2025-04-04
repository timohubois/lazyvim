--[[
  Twig support for Neovim

  Provides Twig template development environment with LSP, formatting, and syntax support.

  Features:
  - LSP support via twiggy-language-server
  - Syntax highlighting via treesitter
  - Formatting via djlint and twig-cs-fixer
    - Project-specific config support
--]]

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "twig" })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "twiggy-language-server", "djlint", "twig-cs-fixer" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.twiggy_language_server = {
        filetypes = { "twig" },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
        twig = { "djlint", "twig-cs-fixer" },
      })
      opts.formatters = vim.tbl_deep_extend("force", opts.formatters or {}, {
        ["djlint"] = {
          args = {
            "--reformat",
            "--line-break-after-multiline-tag",
            "--indent=2",
            "--max-attribute-length=80",
            "--max-line-length=120",
            "--profile", "twig",
            "--format-attribute-template-tags",
            "--preserve-blank-lines",
            "--custom-html", "flynt-component",
            "-"
          },
          cwd = require("conform.util").root_file({
            "pyproject.toml",
            "djlint.toml",
            ".djlintrc",
          }),
        },
        ["twig-cs-fixer"] = {
          command = "twig-cs-fixer",
          args = { "fix", "--no-cache", "$FILENAME" },
          stdin = false,
          cwd = require("conform.util").root_file({
            ".twig-cs-fixer.php",
            ".php-cs-fixer.php",
            ".php-cs-fixer.dist.php",
          }),
        },
      })
      return opts
    end,
  },
}
