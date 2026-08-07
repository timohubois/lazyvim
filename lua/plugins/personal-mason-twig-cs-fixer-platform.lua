--[[
  Mason twig-cs-fixer platform compatibility for Neovim

  Keeps Mason's global twig-cs-fixer installation usable across projects with different PHP versions.

  Features:
  - Hooks into Mason's twig-cs-fixer install event
  - Reads twig-cs-fixer's own minimum PHP constraint from composer.json
  - Sets Composer's platform.php to that minimum
  - Re-runs Composer update inside the Mason package

  Reason:
  - Mason installs PHP tools globally, while direnv, Nix, and mise can expose different PHP versions per project
--]]

return {
  {
    "mason-org/mason.nvim",
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
          local ok, registry = pcall(require, "mason-registry")
          if not ok then
            return
          end

          local package_name = "twig-cs-fixer"

          local function get_min_php_version(install_path)
            local composer_json_path = install_path .. "/vendor/vincentlanglet/twig-cs-fixer/composer.json"
            local lines = vim.fn.readfile(composer_json_path)
            local composer_json = vim.json.decode(table.concat(lines, "\n"))
            local constraint = composer_json.require and composer_json.require.php
            local version = constraint and constraint:match(">=%s*(%d+%.%d+%.?%d*)")

            if not version then
              return nil
            end

            if #vim.split(version, ".", { plain = true }) == 2 then
              version = version .. ".0"
            end

            return version
          end

          local function configure_platform(pkg)
            if pkg.name ~= package_name or not pkg:is_installed() then
              return
            end

            local install_path = pkg:get_install_path()
            local min_php_version = get_min_php_version(install_path)

            if not min_php_version then
              return
            end

            vim.system(
              { "composer", "config", "platform.php", min_php_version },
              { cwd = install_path },
              function(config_result)
                if config_result.code ~= 0 then
                  vim.schedule(function()
                    vim.notify("Failed to configure twig-cs-fixer PHP platform.", vim.log.levels.ERROR)
                  end)
                  return
                end

                vim.system(
                  { "composer", "update", "--no-dev", "--optimize-autoloader" },
                  { cwd = install_path },
                  function(update_result)
                    if update_result.code ~= 0 then
                      vim.schedule(function()
                        vim.notify("Failed to update twig-cs-fixer after PHP platform change.", vim.log.levels.ERROR)
                      end)
                    end
                  end
                )
              end
            )
          end

          registry:on("package:install:success", function(pkg)
            configure_platform(pkg)
          end)
        end,
      })
    end,
  },
}
