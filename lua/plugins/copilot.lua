--[[
  GitHub Copilot configuration for Neovim

  Configures GitHub Copilot with telemetry disabled.
  This configuration will only take effect if copilot is actually loaded.
--]]

return {
  {
    "zbirenbaum/copilot.lua",
    optional = true, -- Only configure if the plugin is actually loaded
    opts = {
      server_opts_overrides = {
        settings = {
          telemetry = {
            telemetryLevel = "off"
          }
        }
      }
    }
  }
}
