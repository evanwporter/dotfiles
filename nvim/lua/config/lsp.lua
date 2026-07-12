vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
        "--query-driver=/run/current-system/sw/bin/clang++,/run/current-system/sw/bin/g++,/nix/store/*/bin/clang++,/nix/store/*/bin/g++",
    },
})

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
        },
    },
})

vim.lsp.config("nil_ls", {})

vim.lsp.config("pyright", {
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
            },
        },
    },
})

vim.lsp.config("yaml_language_server", {
    -- Have to add this for yamlls to understand that we support line folding
    capabilities = {
        textDocument = {
            foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            },
        },
    },
    settings = {
        redhat = { telemetry = { enabled = false } },
        yaml = {
            keyOrdering = false,
            format = {
                enable = false,
            },
            validate = true,
        },
    },
})

vim.lsp.config("neocmake", {
    cmd = {
        "neocmakelsp",
    },
    filetypes = {
        "cmake",
    },
    root_markers = {
        "CMakePresets.json",
        "CTestConfig.cmake",
        ".git",
    },
    init_options = {
        buildDirectory = "build",
    },
})

vim.lsp.config("slang_server", {
    name = "slang-server",
    cmd = {
        vim.fn.expand("~/slang-server/build/debug/bin/slang-server"),
    },
    filetypes = {
        "systemverilog",
        "verilog",
    },
    single_file_support = true,
})

vim.lsp.enable({
    "clangd",
    "yaml_language_server",
    "lua_ls",
    "nil_ls",
    "pyright",
    "rust_analyzer",
    "slang_server",
    "neocmake",
})
