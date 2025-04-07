--[[
  Snacks Explorer for Neovim

  Provides enhanced file explorer with hidden files support.

  Features:
  - Hidden files visibility by default
  - Shows gitignored files
  - Lazy loading for better startup
  - Configurable via opts

  See: https://github.com/folke/snacks.nvim
--]]

return {
  {
    "folke/snacks.nvim",
    event = "VeryLazy",
    opts = {
      picker = {
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
          },
        },
      },
    },
  },
}
