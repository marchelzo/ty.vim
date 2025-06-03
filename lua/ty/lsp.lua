local M = {}

function M.setup()
  vim.lsp.config('tyd', {
    cmd = { 'tyd' },
    filetypes = { 'ty' },
    root_dir = function (bufnr, cb)
      cb(vim.loop.cwd())
    end,
    settings = {},
    on_attach = function(client, bufnr)
      local ok, sig = pcall(require, "lsp_signature")
      if ok then
        sig.on_attach({
          bind = true,
          handler_opts = { border = "rounded" },
          close_timeout = 0,
          hint_enable = false,
          floating_window = true,
        }, bufnr)
      end
    end,
  })

  vim.lsp.set_log_level('TRACE')

end

return M

