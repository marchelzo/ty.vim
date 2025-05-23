local M = {}

function M.setup()
  local lspconfig = require('lspconfig')

  vim.lsp.config('tyd', {
    cmd = { '/usr/local/bin/tyd' },
    filetypes = { 'ty' },
    root_dir = function (bufnr, cb)
      cb(lspconfig.util.find_git_ancestor('.') or vim.loop.cwd())
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

