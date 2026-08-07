local nix_parsers = vim.env.NVIM_TREESITTER_PARSERS

vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local lazy_opts = {
    spec = {
        { import = "plugins" },
        { import = "plugins.languages" },
        { import = "plugins.editor" },
        { import = "plugins.ui" },
        { import = "plugins.coding" },
    },

    install = { colorscheme = { "habamax" } },
    checker = { enabled = true },

    change_detection = {
        notify = false,
    },

    performance = {
        rtp = {
            paths = nix_parsers and { nix_parsers } or {},
        },
    },
}

if mnw ~= nil then
    lazy_opts.dev = {
        path = mnw.configDir .. "/pack/mnw/opt",
        patterns = { "" },
        fallback = true,
    }

    lazy_opts.performance.reset_packpath = false
    lazy_opts.performance.rtp.reset = false
    lazy_opts.install.missing = true
else
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
        local lazyrepo = "https://github.com/folke/lazy.nvim.git"
        local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
        if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
                { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
                { out, "WarningMsg" },
                { "\nPress any key to exit..." },
            }, true, {})
            vim.fn.getchar()
            os.exit(1)
        end
    end
    vim.opt.rtp:prepend(lazypath)
end

require("lazy").setup(lazy_opts)
