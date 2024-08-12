require "nvchad.options"

-- add yours here!

local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
o.opt.colorcolumn = "80"
o.opt.tabstop = 4
o.opt.softtabstop = 4
o.opt.shiftwidth = 4
o.diagnostic.config({
    virtual_text = false,
    virtual_line = false,
})
o.api.nvim_create_user_command("DiagToggle", function()
    local config = o.diagnostic.config
    local vt = config().virtual_text
    config {
        virtual_text = not vt,
        underline = not vt,
        signs = not vt,
    }
end, { desc = "toggle diagnostic" })
