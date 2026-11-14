vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.termguicolors = true

-- Set space as the custom <leader> key
vim.g.mapleader = " "

-- Install and load plugins
vim.pack.add({
  -- Colorschme
  { src = "https://github.com/rebelot/kanagawa.nvim" }
})

-- If anything else fails, colorscheme stays
vim.cmd.colorscheme("kanagawa")

vim.pack.add({
  -- LSP config defaults
  { src = "https://github.com/neovim/nvim-lspconfig" },
  -- Live code review (for merge conflicts mainly)
  { src = "https://github.com/esmuellert/codediff.nvim" },
  -- Auto-close brackets
  { src = "https://github.com/windwp/nvim-autopairs" },
  -- Code suggestions and completions
  { src = "https://github.com/Saghen/blink.cmp", version = "v1.10.2" }
})

require("codediff").setup({})
require("nvim-autopairs").setup({})

-- Don't newline on completion enters.
-- Don't show completion suggestions for comments.
-- Disable plugin's colorscheme to user our own.
require("blink.cmp").setup({
  enabled = function ()
    local ok, node = pcall(vim.treesitter.get_node)

    if not ok or not node then
      return true
    end

    while node do
      if node:type():find("comment") then
        return false
      end
      node = node:parent()
    end

    return true
  end,

  keymap = {
    preset = "default",
    ["<CR>"] = { "accept", "fallback" }
  },

  completion = {
    menu = {
      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None"
    },
    documentation = {
      window = {
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder"
      }
    }
  }
})

local formatters = { python = "ruff", lua = "emmylua_ls", rust = "rust_analyzer" }

vim.keymap.set("n", "<leader>f", function ()
  local name = formatters[vim.bo.filetype]

  if not name then
    vim.notify("No formatter configured for " .. vim.bo.filetype)
    return
  end

  local clients = vim.lsp.get_clients({
    bufnr = 0,
    name = name,
    method = "textDocument/formatting"
  })

  if #clients == 0 then
    vim.notify(name .. " is not attached or does not support formatting")
    return
  end

  vim.lsp.buf.format({
    name = name,
    async = true
  })
end, { desc = "Format buffer" }
)

vim.keymap.set("n", "<leader>cd", "<cmd>CodeDiff<cr>", {
  desc = "Open Git diff"
})

vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities()
})

vim.lsp.enable({ "ty", "ruff", "emmylua_ls", "rust_analyzer" })
