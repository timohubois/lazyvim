-- avante.lua
return {
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        lazy = true,
        version = false, -- set this if you want to always pull the latest change
        opts = {
          provider = "copilot",
        },
        auto_suggestions_provider = "copilot",
        build = "make",
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
          "stevearc/dressing.nvim",
          "nvim-lua/plenary.nvim",
          "MunifTanjim/nui.nvim",
          "zbirenbaum/copilot.lua"
        },
    }
}
