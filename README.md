# next-lsp-reference

Neovim plugin to jump to the next LSP reference under cursor.

```
vim.pack.add({ -- or other plugin manager
  "https://github.com/marcelbeumer/next-lsp-reference.nvim",
})

-- Example bindings. 
-- Suggestion: put in LspAttach autocmd callback instead.
vim.keymap.set("n", "]r", require("next-lsp-reference").forward, {})
vim.keymap.set("n", "[r", require("next-lsp-reference").backward, {})
```
