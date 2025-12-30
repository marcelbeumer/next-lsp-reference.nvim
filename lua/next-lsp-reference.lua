local M = {}

local jump_to_lsp_reference = function(reverse)
  vim.lsp.buf.references(nil, {
    on_list = function(args)
      local fname = vim.api.nvim_buf_get_name(0)
      local cursor = vim.api.nvim_win_get_cursor(0)
      local curr_pos = { lnum = cursor[1], col = cursor[2] + 1 }

      local refs = {}
      for _, item in ipairs(args.items) do
        if item.filename == fname then
          table.insert(refs, { lnum = item.lnum, col = item.col })
        end
      end

      if #refs == 0 then
        print("LSP reference [0/0]")
        return
      end

      table.sort(refs, function(a, b)
        return a.lnum < b.lnum or (a.lnum == b.lnum and a.col < b.col)
      end)

      local target_idx = reverse and #refs or 1

      if reverse then
        for i = #refs, 1, -1 do
          local ref = refs[i]
          if ref.lnum < curr_pos.lnum or (ref.lnum == curr_pos.lnum and ref.col < curr_pos.col) then
            target_idx = i
            break
          end
        end
      else
        for i, ref in ipairs(refs) do
          if ref.lnum > curr_pos.lnum or (ref.lnum == curr_pos.lnum and ref.col > curr_pos.col) then
            target_idx = i
            break
          end
        end
      end

      print("LSP reference [" .. target_idx .. "/" .. #refs .. "]")
      vim.fn.setpos(".", { 0, refs[target_idx].lnum, refs[target_idx].col })
    end,
  })
end

M.next = function()
  jump_to_lsp_reference(false)
end

M.prev = function()
  jump_to_lsp_reference(true)
end

return M
