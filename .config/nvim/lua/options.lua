require "nvchad.options"

-- add yours here!

local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
o.colorcolumn = "80"
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
vim.diagnostic.config({
    virtual_text = false,
    virtual_line = false,
})
vim.api.nvim_create_user_command("DiagToggle", function()
    local config = vim.diagnostic.config
    local vt = config().virtual_text
    config {
        virtual_text = not vt,
        underline = not vt,
        signs = not vt,
    }
end, { desc = "toggle diagnostic" })
