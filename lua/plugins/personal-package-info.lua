--[[
  package.json dependency information for Neovim

  Configures package-info.nvim to show npm package versions in package.json files.

  Features:
  - Diagnostic-themed highlights
  - which-key group for package actions
  - Buffer-local keymaps for package.json files
--]]

return {
  "vuki656/package-info.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "folke/which-key.nvim",
  },
  event = { "BufRead package.json", "BufNewFile package.json" },
  config = function()
    require("package-info").setup({
      hide_up_to_date = true,
    })

    -- Link to existing diagnostic colors to match theme
    vim.api.nvim_set_hl(0, "PackageInfoOutdatedVersion", { link = "DiagnosticError" })
    vim.api.nvim_set_hl(0, "PackageInfoUpToDateVersion", { link = "DiagnosticOk" })
    vim.api.nvim_set_hl(0, "PackageInfoInErrorVersion", { link = "DiagnosticWarn" })

    -- Register which-key groups following official keybinding convention
    local wk = require("which-key")
    wk.add({
      { "<leader>n", group = "npm/package" },
    })

    -- Helper function to set buffer-local keybindings
    local function set_package_info_keymaps(bufnr)
      vim.keymap.set(
        "n",
        "<leader>ns",
        require("package-info").show,
        { buffer = bufnr, desc = "Show Package Versions" }
      )
      vim.keymap.set(
        "n",
        "<leader>nc",
        require("package-info").hide,
        { buffer = bufnr, desc = "Hide Package Versions" }
      )
      vim.keymap.set(
        "n",
        "<leader>nt",
        require("package-info").toggle,
        { buffer = bufnr, desc = "Toggle Package Versions" }
      )
      vim.keymap.set("n", "<leader>nu", require("package-info").update, { buffer = bufnr, desc = "Update Package" })
      vim.keymap.set("n", "<leader>nd", require("package-info").delete, { buffer = bufnr, desc = "Delete Package" })
      vim.keymap.set(
        "n",
        "<leader>ni",
        require("package-info").install,
        { buffer = bufnr, desc = "Install New Package" }
      )
      vim.keymap.set(
        "n",
        "<leader>np",
        require("package-info").change_version,
        { buffer = bufnr, desc = "Change Package Version" }
      )
    end

    -- Set keymaps for current buffer (handles initial load)
    set_package_info_keymaps(0)

    -- Register autocmd for future package.json buffers
    vim.api.nvim_create_autocmd("BufRead", {
      group = vim.api.nvim_create_augroup("PackageInfoKeymaps", { clear = true }),
      pattern = "package.json",
      callback = function(event)
        set_package_info_keymaps(event.buf)
      end,
    })
  end,
}
