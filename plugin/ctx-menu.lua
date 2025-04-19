if _G.CtxMenuLoaded then
    return
end

_G.CtxMenuLoaded = true

if vim.fn.has("nvim-0.7") == 0 then
    -- vim.cmd("command! CtxMenu lua require('ctx-menu').do_smth()")
else
    -- vim.api.nvim_create_user_command("CtxMenu", function()
    --     require("ctx-menu").do_smth()
    -- end, {})
end
