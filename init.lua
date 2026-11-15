vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.termguicolors = true

-- Set space as the custom <leader> key
vim.g.mapleader = " "

-- Shortcut to show line's diagnostics
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {
  desc = "Show diagnostic message"
})

-- Build telescope-fzf-native (fzf port), recommended for Telescope plugin
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind

    if name == "telescope-fzf-native.nvim" and (kind == "install" or kind == "update") then
      local result = vim.system({ "make" }, {
        cwd = ev.data.path,
        text = true,
      }):wait()

      if result.code ~= 0 then
        error("telescope-fzf-native build failed:\n" .. (result.stderr or ""))
      end
    end
  end,
})

-- Install and load plugins
vim.pack.add({
  -- Colorschme
  { src = "https://github.com/rebelot/kanagawa.nvim" }
})

-- If anything else fails, colorscheme stays
vim.cmd.colorscheme("kanagawa")

-- The rest of plugins
vim.pack.add({
  -- LSP config defaults
  { src = "https://github.com/neovim/nvim-lspconfig" },
  -- Live code review (for merge conflicts mainly)
  { src = "https://github.com/esmuellert/codediff.nvim" },
  -- Auto-close brackets
  { src = "https://github.com/windwp/nvim-autopairs" },
  -- Code suggestions and completions
  { src = "https://github.com/Saghen/blink.cmp",        version = "v1.10.2" },
  -- Nerd font icons
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  -- Recommended plugin for Telescope (with the build cmd earlier)
  { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
  -- Telescope to easily find, filter, preview, pick files
  -- 2026/11/15: migration away from Plenary not in master yet
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
})

require("codediff").setup({})
require("nvim-autopairs").setup({})
require("telescope").load_extension("fzf")

-- Don't newline on completion enters
-- Don't show completion suggestions for comments
-- Match completion popup colors to the active colorscheme
require("blink.cmp").setup({
  enabled = function()
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

-- Define formatters and the shortcut to format
local formatters = {
  python = "ruff",
  lua = "lua_ls",
  rust = "rust_analyzer"
}

vim.keymap.set("n", "<leader>f", function()
  local name = formatters[vim.bo.filetype]

  if not name then
    vim.notify("No formatter configured for " .. vim.bo.filetype)
    return
  end

  vim.lsp.buf.format({
    name = name,
    async = true
  })
end, { desc = "Format buffer" })

-- Shortcut for CodeDiff plugin
vim.keymap.set("n", "<leader>cd", "<cmd>CodeDiff<cr>", {
  desc = "Open Git diff"
})

-- Enable code suggestions for all LSPs
vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities()
})

-- Specific config for Lua LS to:
--   - recognize vim in this config
--   - find installed plugins from this file
--   - set minimalistic formatting config
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" }
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false
      },
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
          quote_style = "double",
        }
      }
    }
  }
})

vim.lsp.enable({ "ty", "ruff", "lua_ls", "rust_analyzer" })
