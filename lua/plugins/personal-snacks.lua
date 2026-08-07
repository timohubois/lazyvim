--[[
  Snacks for Neovim

  Configures Snacks picker and image defaults.

  Features:
  - Picker defaults for hidden and ignored files
  - Image support using Snacks' default image settings

  See: https://github.com/folke/snacks.nvim
--]]

return {
  {
    "folke/snacks.nvim",
    event = "VeryLazy",
    opts = {
      image = {},
      picker = {
        sources = {
          files = {
            hidden = true,
          },
          explorer = {
            hidden = true,
            ignored = true,
          },
        },
      },
    },
  },
}
