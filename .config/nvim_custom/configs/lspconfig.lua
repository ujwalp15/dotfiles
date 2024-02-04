local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

local merge_tb = vim.tbl_deep_extend

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "tsserver", "clangd", "pyright", "yamlls", "bashls", "jsonls"}

for _, lsp in ipairs(servers) do
    local opts = {
		on_attach = on_attach,
		capabilities = capabilities,
	}

    local exists, settings = pcall(require, "custom.configs.server_settings." .. lsp)
	if exists then
		opts = merge_tb("force", settings, opts)
	end

    lspconfig[lsp].setup(opts)
end

-- 
-- lspconfig.pyright.setup { blabla}
