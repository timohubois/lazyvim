--[[
  Stylelint formatting for Neovim

  Configures conform.nvim to use stylelint for CSS-family files.

  Features:
  - Formatting for CSS
  - Formatting for Less
  - Formatting for SCSS and Sass
--]]

return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
        css = { "stylelint" },
        less = { "stylelint" },
        scss = { "stylelint" },
        sass = { "stylelint" },
      })

      return opts
    end,
  },
}
