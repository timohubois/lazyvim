return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        stylelint_lsp = {
          settings = {
            stylelintplus = {
              autoFixOnFormat = true,
              autoFixOnSave = true,
              validateOnSave = true,
            },
          },
        },
      },
    },
  },
}
