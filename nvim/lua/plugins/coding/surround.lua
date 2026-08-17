return {
    {
        "echasnovski/mini.surround",
        keys = {
            { "sa", desc = "Add surrounding", mode = { "n", "x" } },
            { "sd", desc = "Delete surrounding" },
            { "sr", desc = "Replace surrounding" },
            { "sh", desc = "Highlight surrounding" },
        },
        opts = {
            mappings = {
                add = "sa",
                delete = "sd",
                find = "",
                find_left = "",
                highlight = "sh",
                replace = "sr",
                update_n_lines = "",
            },
        },
    },
}
