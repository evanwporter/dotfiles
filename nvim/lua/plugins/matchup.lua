return {
    {
        "andymass/vim-matchup",
        lazy = false,
        -- enabled = false,
        init = function()
            -- Combine Tree-sitter delimiters with filetype-specific
            -- `b:match_words` pairs, including SystemVerilog begin/end.
            vim.g.matchup_treesitter_include_match_words = true
        end,
    },
}
