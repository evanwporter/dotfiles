local aucmd = vim.api.nvim_create_autocmd

local function augroup(name, fnc)
    fnc(vim.api.nvim_create_augroup(name, { clear = true }))
end

-- Handle plugin post-install tasks
augroup("nvim-pack-builds", function(g)
    aucmd("PackChanged", {
        group = g,
        callback = function(ev)
            local name, kind = ev.data.spec.name, ev.data.kind

            -- Download fff binary after installation
            if name == "fff" and (kind == "install" or kind == "update") then
                if not ev.data.active then
                    vim.cmd.packadd("fff")
                end
                require("fff.download").download_or_build_binary()
            end

            -- Download blink.pairs binary after installation
            if name == "blink.pairs" and (kind == "install" or kind == "update") then
                if not ev.data.active then
                    vim.cmd.packadd("blink.pairs")
                end
                local ok, pairs = pcall(require, "blink.pairs")
                if ok then
                    pairs.download():pwait(60000)
                end
            end
        end,
    })
end)
