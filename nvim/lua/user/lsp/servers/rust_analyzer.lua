local M = {}

M.setup = function(on_attach, capabilities)
  require("lspconfig").rust_analyzer.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        assist = {importGranularity = "module", importPrefix = "by_self"},
        cargo = {loadOutDirsFromCheck = true},
        procMacro = {enable = true}
      }
    }
  })
end

return M
