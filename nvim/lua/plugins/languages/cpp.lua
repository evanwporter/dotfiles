-- C/C++ extensions for clangd
-- Installation handled by lua/sources.lua

return {
    "clangd_extensions.nvim",
    lazy = true,
    ft = { "c", "cpp", "h", "hpp" },
    after = function()
        require("clangd_extensions").setup({
            ast = {
                -- These are unicode, should be available in any font
                role_icons = {
                    type = "🄣",
                    declaration = "🄓",
                    expression = "🄔",
                    statement = ";",
                    specifier = "🄢",
                    ["template argument"] = "🆃",
                },
                kind_icons = {
                    Compound = "🄲",
                    Recovery = "🅁",
                    TranslationUnit = "🅄",
                    PackExpansion = "🄿",
                    TemplateTypeParm = "🅃",
                    TemplateTemplateParm = "🅃",
                    TemplateParamObject = "🅃",
                },
                highlights = {
                    detail = "Comment",
                },
            },
            memory_usage = {
                border = "none",
            },
            symbol_info = {
                border = "none",
            },
        })
    end,
}
