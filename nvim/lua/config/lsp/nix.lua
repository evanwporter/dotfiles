vim.lsp.config("nixd", {
    cmd = { "nixd" },
    filetypes = { "nix" },
    root_markers = { "flake.nix", ".git" },
    settings = {
        nixd = {
            nixpkgs = {
                expr = "import (builtins.getFlake (toString ./.)).inputs.nixpkgs {}",
            },
            options = {
                nixos_laptop = {
                    expr = "(builtins.getFlake (toString ./.)).nixosConfigurations.laptop.options",
                },
                nixos_wsl = {
                    expr = "(builtins.getFlake (toString ./.)).nixosConfigurations.wsl.options",
                },
                home_manager = {
                    expr = "(builtins.getFlake (toString ./.)).homeConfigurations.evanp.options",
                },
                home_manager_nixos = {
                    expr = "(builtins.getFlake (toString ./.)).nixosConfigurations.laptop.options.home-manager.users.type.getSubOptions []",
                },
            },
            formatting = {
                command = {
                    "alejandra",
                    "--experimental-config",
                    vim.fn.expand("~/.config/alejandra/alejandra.toml"),
                },
            },
        },
    },
})
vim.lsp.enable("nixd")
