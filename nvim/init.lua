------------------------------------------------------------
-- Vim general settings
------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })

------------------------------------------------------------
-- Plugins (built-in vim.pack)
------------------------------------------------------------
vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  "https://github.com/sainnhe/everforest",
})

------------------------------------------------------------
-- Theme
------------------------------------------------------------
vim.o.termguicolors = true
vim.o.background = "light"
vim.g.everforest_background = "soft"
vim.cmd.colorscheme("everforest")

------------------------------------------------------------
-- Telescope
------------------------------------------------------------
require("telescope").setup({})
local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope Buffers" })
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Telescope Recent files" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Telescope Keymaps" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Telescope Diagnostics" })

------------------------------------------------------------
-- Godot, GDScript
------------------------------------------------------------
vim.lsp.config("gdscript", {
  cmd = vim.lsp.rpc.connect("127.0.0.1", 6005),
  filetypes = { "gdscript" },
  root_markers = { "project.godot", ".git" },
})
vim.lsp.enable("gdscript")

-- Rescan .gd source files (requires the rescan godit editor pluggin)
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.gd",
  callback = function()
    vim.fn.system("touch " .. vim.fn.getcwd() .. "/.rescan")
  end,
})

------------------------------------------------------------
-- LSP
------------------------------------------------------------
-- LSP keymaps, set only when a server attaches
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
    end
    map("gd", builtin.lsp_definitions, "LSP Go to definition")
    map("gr", builtin.lsp_references, "LSP References")
    map("gi", builtin.lsp_implementations, "LSP Implementations")
    map("gy", builtin.lsp_type_definitions, "LSP Type definition")
    map("<leader>fs", builtin.lsp_document_symbols, "LSP Document symbols")
    map("<leader>fw", builtin.lsp_dynamic_workspace_symbols, "LSP Workspace symbols")
    -- Neovim defaults: K (hover), grn (rename), gra (code action),
    -- grr (references), gO (document symbols)
  end,
})

------------------------------------------------------------
-- Conform: format on save
------------------------------------------------------------
require("conform").setup({
  formatters_by_ft = {
    gdscript = { "gdscript-formatter" },
    lua = { "stylua" },
    go = { "goimports" },
  },
  format_on_save = {
    timeout_ms = 2000,
    lsp_format = "fallback", -- other filetypes use LSP formatting if available
  },
})
