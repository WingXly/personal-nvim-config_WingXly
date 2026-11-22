require('lualine').setup({
    options = {
        theme = 'tokyonight'
    },
    sections = {
        lualine_x = {
            -- 显示当前缓冲区挂载的 LSP 客户端（没有则不显示）
            {
                function()
                    local names = {}
                    for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
                        names[#names + 1] = c.name
                    end
                    if #names == 0 then
                        return ''
                    end
                    return 'LSP:' .. table.concat(names, ',')
                end,
                color = { fg = '#79c0ff' },
            },
            -- 诊断计数（错误/警告/提示）
            'diagnostics',
            'encoding',
            'fileformat',
            'filetype',
        },
    },
})
