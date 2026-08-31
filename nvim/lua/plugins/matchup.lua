return {
    {
        "andymass/vim-matchup",
        -- This plugin allows me to match begin ... end
        ft = { "systemverilog", "verilog" },
        enabled = false,
        init = function()
            -- Keep matchup's motions and text objects, but do not highlight
            -- matching delimiters or words under the cursor.
            vim.g.matchup_matchparen_enabled = 0

            -- Combine Tree-sitter delimiters with filetype-specific
            -- `b:match_words` pairs
            vim.g.matchup_treesitter_include_match_words = true
        end,
    },
}
