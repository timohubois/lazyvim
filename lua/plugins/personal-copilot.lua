--[[
  GitHub Copilot configuration for Neovim

  Configures GitHub Copilot with privacy-conscious defaults.

  Features:
  - Telemetry disabled
  - Optional configuration only when Copilot is loaded
--]]

return {
  {
    "zbirenbaum/copilot.lua",
    optional = true, -- Only configure if the plugin is actually loaded
    opts = {
      server_opts_overrides = {
        settings = {
          telemetry = {
            telemetryLevel = "off",
          },
        },
      },
    },
  },
}
