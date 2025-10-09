--[[
  Package.json dependency management for Neovim

  Provides visual package version information and dependency management
  commands for JavaScript/TypeScript projects with package.json files.

  Features:
  - Virtual text showing latest dependency versions
  - Quick package update/install/delete commands
  - Automatic package manager detection (npm/yarn/pnpm)

  See: https://github.com/vuki656/package-info.nvim
--]]

return {
  "vuki656/package-info.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  event = { "BufRead package.json", "BufNewFile package.json" },
  config = function()
    require("package-info").setup({
      hide_up_to_date = true,
    })
    
    -- Link to existing diagnostic colors to match theme
    vim.api.nvim_set_hl(0, "PackageInfoOutdatedVersion", { link = "DiagnosticError" })
    vim.api.nvim_set_hl(0, "PackageInfoUpToDateVersion", { link = "DiagnosticOk" })
    vim.api.nvim_set_hl(0, "PackageInfoInErrorVersion", { link = "DiagnosticWarn" })

    -- Set up buffer-local keymaps only for package.json
    vim.api.nvim_create_autocmd("BufRead", {
      pattern = "package.json",
      callback = function(ev)
        vim.keymap.set("n", "<leader>cpt", function() require("package-info").toggle() end, { buffer = ev.buf, desc = "Toggle package info" })
        vim.keymap.set("n", "<leader>cpu", function() require("package-info").update() end, { buffer = ev.buf, desc = "Update package" })
        vim.keymap.set("n", "<leader>cpd", function() require("package-info").delete() end, { buffer = ev.buf, desc = "Delete package" })
        vim.keymap.set("n", "<leader>cpi", function() require("package-info").install() end, { buffer = ev.buf, desc = "Install package" })
        vim.keymap.set("n", "<leader>cpv", function() require("package-info").change_version() end, { buffer = ev.buf, desc = "Change version" })
      end,
    })
  end,
}