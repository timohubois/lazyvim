-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Add a keymap to exit terminal mode in LazyVim
vim.keymap.set("t", "<esc><esc>", "<cmd>stopinsert<cr>", { desc = "Exit Terminal Mode" })
