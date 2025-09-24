--[[
  JavaScript support for Neovim

  Provides JavaScript development environment with StandardJS linting and formatting.

  Features:
  - Linting via StandardJS
    - Project-specific config detection
  - Automatic installation via Mason

  See: https://github.com/standard/standard
--]]

return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "standardjs" })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = "BufReadPre",
    opts = {
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        javascript = { "standardjs" },
      },
      linters = {
        standardjs = {
          cmd = "standard",
          args = { "--stdin" },
          stdin = true,
          stream = "stdout",
          ignore_exitcode = true,
          parser = function(output, bufnr)
            local diagnostics = {}
            for _, line in ipairs(vim.split(output, "\n")) do
              local filename, line_num, col_num, message = line:match("([^:]+):(%d+):(%d+):(.+)")
              if filename then
                table.insert(diagnostics, {
                  lnum = tonumber(line_num) - 1,
                  col = tonumber(col_num) - 1,
                  end_lnum = tonumber(line_num) - 1,
                  end_col = tonumber(col_num) - 1,
                  message = message,
                  severity = vim.diagnostic.severity.ERROR,
                  source = "standardjs",
                  bufnr = bufnr,
                })
              end
            end
            return diagnostics
          end,
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
        javascript = { "standard" },
      })
      opts.formatters = vim.tbl_deep_extend("force", opts.formatters or {}, {
        ["standard"] = {
          command = "standard",
          args = { "--fix", "-" },
          stdin = true,
        },
      })
      return opts
    end,
  },
}
