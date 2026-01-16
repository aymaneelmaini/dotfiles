vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = 'a'

vim.o.showmode = false

vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true

vim.o.tabstop = 4 -- Number of spaces a tab counts for
vim.o.shiftwidth = 4 -- Number of spaces for each indentation
vim.o.softtabstop = 4 -- Number of spaces for tab in insert mode
vim.o.expandtab = true -- Use spaces instead of tabs

vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'

vim.o.updatetime = 250

vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split'

vim.o.cursorline = true

vim.o.scrolloff = 10

vim.o.confirm = true

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- for interactvity with make commands when building clox
vim.keymap.set('n', '<leader>m', function()
    vim.cmd 'split | terminal make'
end, { desc = '[M]ake - compile in terminal' })

-- Buffer navigation and management
vim.keymap.set('n', '<leader>bn', ':bnext<CR>', { desc = '[B]uffer [N]ext' })
vim.keymap.set('n', '<leader>bp', ':bprev<CR>', { desc = '[B]uffer [P]revious' })
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { desc = '[B]uffer [D]elete' })
vim.keymap.set('n', '<leader>bD', ':bwipeout<CR>', { desc = '[B]uffer [D]elete (wipeout)' })

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave' }, {
    desc = 'Auto-save file on change',
    group = vim.api.nvim_create_augroup('kickstart-auto-save', { clear = true }),
    callback = function()
        if vim.bo.modified and vim.bo.buftype == '' and vim.fn.expand '%' ~= '' then
            vim.cmd 'silent! write'
        end
    end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup({
    'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically

    -- Use `opts = {}` to automatically pass options to a plugin's `setup()` function, forcing the plugin to be loaded.
    --

    -- Alternatively, use `config = function() ... end` for full control over the configuration.
    -- If you prefer to call `setup` explicitly, use:
    --    {
    --        'lewis6991/gitsigns.nvim',
    --        config = function()
    --            require('gitsigns').setup({
    --                -- Your gitsigns configuration here
    --            })
    --        end,
    --    }
    --
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '█' },
                change = { text = '█' },
                delete = { text = '█' },
                topdelete = { text = '█' },
                changedelete = { text = '█' },
            },
            current_line_blame = true, -- Enable inline blame by default
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                delay = 300, -- Delay in ms before showing blame
                ignore_whitespace = false,
            },
            current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        },
    },

    {
        'folke/which-key.nvim',
        event = 'VimEnter',
        opts = {
            delay = 0,
            icons = {
                mappings = vim.g.have_nerd_font,
                keys = vim.g.have_nerd_font and {} or {
                    Up = '<Up> ',
                    Down = '<Down> ',
                    Left = '<Left> ',
                    Right = '<Right> ',
                    C = '<C-…> ',
                    M = '<M-…> ',
                    D = '<D-…> ',
                    S = '<S-…> ',
                    CR = '<CR> ',
                    Esc = '<Esc> ',
                    ScrollWheelDown = '<ScrollWheelDown> ',
                    ScrollWheelUp = '<ScrollWheelUp> ',
                    NL = '<NL> ',
                    BS = '<BS> ',
                    Space = '<Space> ',
                    Tab = '<Tab> ',
                    F1 = '<F1>',
                    F2 = '<F2>',
                    F3 = '<F3>',
                    F4 = '<F4>',
                    F5 = '<F5>',
                    F6 = '<F6>',
                    F7 = '<F7>',
                    F8 = '<F8>',
                    F9 = '<F9>',
                    F10 = '<F10>',
                    F11 = '<F11>',
                    F12 = '<F12>',
                },
            },

            spec = {
                { '<leader>s', group = '[S]earch' },
                { '<leader>t', group = '[T]oggle' },
                { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
            },
        },
    },

    {
        'nvim-telescope/telescope.nvim',
        event = 'VimEnter',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',

                build = 'make',

                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
            { 'nvim-telescope/telescope-ui-select.nvim' },

            { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
        },
        config = function()
            require('telescope').setup {
                extensions = {
                    ['ui-select'] = {
                        require('telescope.themes').get_dropdown(),
                    },
                },
            }

            pcall(require('telescope').load_extension, 'fzf')
            pcall(require('telescope').load_extension, 'ui-select')

            local builtin = require 'telescope.builtin'
            vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
            vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
            vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
            vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
            vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
            vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
            vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
            vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
            vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
            vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

            vim.keymap.set('n', '<leader>/', function()
                builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                    winblend = 10,
                    previewer = false,
                })
            end, { desc = '[/] Fuzzily search in current buffer' })

            vim.keymap.set('n', '<leader>s/', function()
                builtin.live_grep {
                    grep_open_files = true,
                    prompt_title = 'Live Grep in Open Files',
                }
            end, { desc = '[S]earch [/] in Open Files' })

            vim.keymap.set('n', '<leader>sn', function()
                builtin.find_files { cwd = vim.fn.stdpath 'config' }
            end, { desc = '[S]earch [N]eovim files' })
        end,
    },
    -- cursor ninja animation
    {
        'sphamba/smear-cursor.nvim',
        opts = {},
    },

    -- LSP Plugins
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            },
        },
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'mason-org/mason.nvim', opts = {} },
            'mason-org/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',

            { 'j-hui/fidget.nvim', opts = {} },

            'saghen/blink.cmp',
        },
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or 'n'
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    map('gn', vim.lsp.buf.rename, '[R]e[n]ame')

                    map('ga', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
                    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

                    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

                    map('gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

                    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                    map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

                    map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

                    map('gt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

                    ---@param client vim.lsp.Client
                    ---@param method vim.lsp.protocol.Method
                    ---@param bufnr? integer some lsp support methods only in specific files
                    ---@return boolean
                    local function client_supports_method(client, method, bufnr)
                        if vim.fn.has 'nvim-0.11' == 1 then
                            return client:supports_method(method, bufnr)
                        else
                            return client.supports_method(method, { bufnr = bufnr })
                        end
                    end

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
                        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })

                        vim.api.nvim_create_autocmd('LspDetach', {
                            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                            end,
                        })
                    end

                    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
                        map('<leader>th', function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                        end, '[T]oggle Inlay [H]ints')
                    end
                end,
            })

            -- Configure diagnostics to be less noisy
            -- vim.diagnostic.config {
            --     severity_sort = true,
            --     float = { border = 'rounded', source = 'if_many' },
            --     underline = { severity = vim.diagnostic.severity.ERROR },
            --     signs = vim.g.have_nerd_font and {
            --         text = {
            --             [vim.diagnostic.severity.ERROR] = '󰅚 ',
            --             [vim.diagnostic.severity.WARN] = '󰀪 ',
            --             [vim.diagnostic.severity.INFO] = '󰋽 ',
            --             [vim.diagnostic.severity.HINT] = '󰌶 ',
            --         },
            --     } or {},
            --     virtual_text = {
            --         severity = { min = vim.diagnostic.severity.WARN }, -- Only show WARN and above in virtual text
            --         source = 'if_many',
            --         spacing = 2,
            --         format = function(diagnostic)
            --             local diagnostic_message = {
            --                 [vim.diagnostic.severity.ERROR] = diagnostic.message,
            --                 [vim.diagnostic.severity.WARN] = diagnostic.message,
            --                 [vim.diagnostic.severity.INFO] = diagnostic.message,
            --                 [vim.diagnostic.severity.HINT] = diagnostic.message,
            --             }
            --             return diagnostic_message[diagnostic.severity]
            --         end,
            --     },
            -- }

            vim.diagnostic.config {
                severity_sort = true,

                float = {
                    border = 'rounded',
                    source = 'if_many',
                },

                -- ONLY underline real errors
                underline = {
                    severity = vim.diagnostic.severity.ERROR,
                },

                -- Show signs only for errors
                signs = {
                    severity = { min = vim.diagnostic.severity.ERROR },
                },

                -- Disable virtual text for warnings/info/hints
                virtual_text = {
                    severity = { min = vim.diagnostic.severity.ERROR },
                },
            }

            local capabilities = require('blink.cmp').get_lsp_capabilities()

            local servers = {
                clangd = {
                    cmd = {
                        'clangd',
                        '--background-index',
                        -- '--clang-tidy',
                        '--header-insertion=iwyu',
                        '--completion-style=detailed',
                        '--function-arg-placeholders',
                        -- Reduce noise from clangd
                        '--diagnostic-hotkeys=false',
                        '--enable-config',
                    },
                    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
                    -- Disable certain diagnostics that are noisy
                    init_options = {
                        clangdFileStatus = true,
                        usePlaceholders = true,
                        completeUnimportedMembers = true,
                    },
                    on_attach = function(client, bufnr)
                        -- Suppress specific clangd diagnostics for C projects
                        if vim.fn.expand '%:e' == 'c' then
                            client.server_capabilities.semanticTokensProvider = nil
                        end
                    end,
                },

                -- Kotlin Language Server
                kotlin_language_server = {},

                -- XML Language Server (for Java - Maven, Spring, etc.)
                lemminx = {},

                gopls = {},
                rust_analyzer = {},
                ts_ls = {},

                lua_ls = {
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = 'Replace',
                            },
                        },
                    },
                },
            }

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                'stylua',
                'clang-format',
                -- 'cpplint',
                'ktlint',
                'markdownlint',
            })
            require('mason-tool-installer').setup { ensure_installed = ensure_installed }

            require('mason-lspconfig').setup {
                ensure_installed = {},
                automatic_installation = false,
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            }
        end,
    },

    {
        'stevearc/conform.nvim',
        event = { 'BufWritePre' },
        cmd = { 'ConformInfo' },
        keys = {
            {
                '<leader>f',
                function()
                    require('conform').format { async = true, lsp_format = 'fallback' }
                end,
                mode = '',
                desc = '[F]ormat buffer',
            },
        },
        opts = {
            notify_on_error = false,
            format_on_save = function(bufnr)
                return {
                    timeout_ms = 500,
                    lsp_format = 'fallback',
                }
            end,
            formatters_by_ft = {
                lua = { 'stylua' },
                c = { 'clang-format' },
                cpp = { 'clang-format' },
                kotlin = { 'ktlint' },
                xml = { 'xmlformat' },
            },
        },
    },

    { -- Autocompletion
        'saghen/blink.cmp',
        event = 'VimEnter',
        version = '1.*',
        dependencies = {
            {
                'L3MON4D3/LuaSnip',
                version = '2.*',
                build = (function()
                    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                        return
                    end
                    return 'make install_jsregexp'
                end)(),
                dependencies = {
                    -- `friendly-snippets` contains a variety of premade snippets.
                    --    See the README about individual language/framework/plugin snippets:
                    --    https://github.com/rafamadriz/friendly-snippets
                    {
                        'rafamadriz/friendly-snippets',
                        config = function()
                            require('luasnip.loaders.from_vscode').lazy_load()
                        end,
                    },
                },
                opts = {},
            },
            'folke/lazydev.nvim',
        },
        --- @module 'blink.cmp'
        --- @type blink.cmp.Config
        opts = {
            keymap = {
                preset = 'default',

                ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
                ['<CR>'] = { 'accept', 'fallback' },
                ['<C-y>'] = { 'accept', 'fallback' },
                ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
                ['<C-e>'] = { 'hide', 'fallback' },
                ['<C-n>'] = { 'select_next', 'fallback' },
                ['<C-p>'] = { 'select_prev', 'fallback' },
                ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
                ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
            },

            appearance = {
                nerd_font_variant = 'mono',
            },

            completion = {
                documentation = { auto_show = false, auto_show_delay_ms = 500 },
            },

            sources = {
                default = { 'lsp', 'path', 'snippets', 'lazydev' },
                providers = {
                    lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
                },
            },

            snippets = { preset = 'luasnip' },

            -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
            -- which automatically downloads a prebuilt binary when enabled.
            --
            -- By default, we use the Lua implementation instead, but you may enable
            -- the rust implementation via `'prefer_rust_with_warning'`
            --
            -- See :h blink-cmp-config-fuzzy for more information
            fuzzy = { implementation = 'lua' },

            -- Shows a signature help window while you type arguments for a function
            signature = { enabled = true },
        },
    },

    {
        'quolpr/quicktest.nvim',
        dependencies = { 'nvim-lua/plenary.nvim', 'akinsho/toggleterm.nvim' },
        config = function()
            require('quicktest').setup {
                mode = 'toggleterm',
            }

            -- Configure C test runner for Criterion with your clox project
            require('quicktest.ft.c').setup {
                -- Change to your project directory and run make test
                command = 'cd /home/geek/codes/personal/projects/language-impls/clox && make test',
            }
        end,
        keys = {
            { '<leader>tl', '<cmd>lua require("quicktest").run_file()<CR>', desc = '[T]est [F]ile' },
            { '<leader>ta', '<cmd>lua require("quicktest").run_all()<CR>', desc = '[T]est [A]ll' },
            { '<leader>tp', '<cmd>lua require("quicktest").run_previous()<CR>', desc = '[T]est [P]revious' },
            { '<leader>ts', '<cmd>lua require("quicktest").stop_current()<CR>', desc = '[T]est [S]top' },
        },
    },

    -- {
    --     'ellisonleao/gruvbox.nvim',
    --     priority = 1000,
    --     config = function()
    --         require('gruvbox').setup {
    --             terminal_colors = true,
    --             undercurl = true,
    --             underline = true,
    --             bold = true,
    --             italic = {
    --                 strings = true,
    --                 emphasis = true,
    --                 comments = true,
    --                 operators = false,
    --                 folds = true,
    --             },
    --             strikethrough = true,
    --             invert_intend_guides = false,
    --         }
    --         vim.cmd.colorscheme 'gruvbox'
    --     end,
    -- },

    {
        'sainnhe/gruvbox-material',
        priority = 1000,
        config = function()
            vim.g.gruvbox_material_transparent_background = 1
            vim.g.gruvbox_material_foreground = 'mix'
            vim.g.gruvbox_material_background = 'hard'
            vim.g.gruvbox_material_ui_contrast = 'high'
            vim.g.gruvbox_material_float_style = 'bright'
            vim.g.gruvbox_material_statusline_style = 'mix'
            vim.g.gruvbox_material_cursor = 'auto'

            -- Zed-like polish
            vim.g.gruvbox_material_disable_italic_comment = 1
            vim.g.gruvbox_material_diagnostic_virtual_text = 'colored'
            vim.g.gruvbox_material_diagnostic_text_highlight = 0

            vim.cmd.colorscheme 'gruvbox-material'
        end,
    },

    { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

    {
        'numToStr/Comment.nvim',
        event = 'VeryLazy',
        opts = {
            padding = true,
            sticky = true,
            toggler = {
                line = 'gcc',
                block = 'gbc',
            },
            opleader = {
                line = 'gc', -- Line-comment keymap
                block = 'gb', -- Block-comment keymap
            },
        },
    },

    -- Multiple Cursors (VSCode-like multi-select)
    {
        'mg979/vim-visual-multi',
        event = 'VeryLazy',
        init = function()
            vim.g.VM_maps = {
                ['Find Under'] = '<C-d>', -- Ctrl+D to select next occurrence (like VSCode)
                ['Find Subword Under'] = '<C-d>',
            }
        end,
    },

    -- Tmux & Neovim navigation integration
    {
        'christoomey/vim-tmux-navigator',
        lazy = false,
        cmd = {
            'TmuxNavigateLeft',
            'TmuxNavigateDown',
            'TmuxNavigateUp',
            'TmuxNavigateRight',
            'TmuxNavigatePrevious',
        },
        keys = {
            { '<C-h>', '<cmd>TmuxNavigateLeft<cr>', desc = 'Navigate left (tmux/nvim)' },
            { '<C-j>', '<cmd>TmuxNavigateDown<cr>', desc = 'Navigate down (tmux/nvim)' },
            { '<C-k>', '<cmd>TmuxNavigateUp<cr>', desc = 'Navigate up (tmux/nvim)' },
            { '<C-l>', '<cmd>TmuxNavigateRight<cr>', desc = 'Navigate right (tmux/nvim)' },
            { '<C-\\>', '<cmd>TmuxNavigatePrevious<cr>', desc = 'Navigate to previous (tmux/nvim)' },
        },
    },

    {
        'vyfor/cord.nvim',
        build = ':Cord update',
        -- opts = {}
    },
    -- Discord Rich Presence
    -- {
    --     'IogaMaster/neocord',
    --     event = 'VeryLazy',
    --     opts = {
    --         logo = 'auto', -- "auto" or url
    --         logo_tooltip = nil, -- nil or string
    --         main_image = 'language', -- "language" or "logo"
    --         client_id = '1157438221865717800', -- Use your own Discord application client id (not recommended)
    --         log_level = nil, -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
    --         debounce_timeout = 10, -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
    --         blacklist = {}, -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
    --         file_assets = nil, -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
    --         show_time = true, -- Show the timer
    --         global_timer = false, -- if set true, timer won't update when any event are triggered
    --
    --         -- Rich Presence text options
    --         editing_text = 'Editing %s', -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
    --         file_explorer_text = 'Browsing %s', -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
    --         git_commit_text = 'Committing changes', -- Format string rendered when committing changes in git (either string or function(filename: string): string)
    --         plugin_manager_text = 'Managing plugins', -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
    --         reading_text = 'Reading %s', -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
    --         workspace_text = 'Working on %s', -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
    --         line_number_text = 'Line %s out of %s', -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
    --         terminal_text = 'Using Terminal', -- Format string rendered when in terminal mode.
    --     },
    -- },

    {
        'echasnovski/mini.nvim',
        config = function()
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
            --  - ci'  - [C]hange [I]nside [']quote
            require('mini.ai').setup { n_lines = 500 }

            -- Add/delete/replace surroundings (brackets, quotes, etc.)
            --
            -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
            -- - sd'   - [S]urround [D]elete [']quotes
            -- - sr)'  - [S]urround [R]eplace [)] [']
            require('mini.surround').setup()

            local statusline = require 'mini.statusline'
            statusline.setup { use_icons = vim.g.have_nerd_font }

            ---@diagnostic disable-next-line: duplicate-set-field
            statusline.section_location = function()
                return '%2l:%-2v'
            end
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        main = 'nvim-treesitter.configs', -- Sets main module to use for opts
        -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
        opts = {
            ensure_installed = { 'bash', 'c', 'cpp', 'kotlin', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'xml' },
            -- Autoinstall languages that are not installed
            auto_install = true,
            highlight = {
                enable = true,
                -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
                --  If you are experiencing weird indenting issues, add the language to
                --  the list of additional_vim_regex_highlighting and disabled languages for indent.
                additional_vim_regex_highlighting = { 'ruby' },
            },
            indent = { enable = true, disable = { 'ruby' } },
        },
        -- There are additional nvim-treesitter modules that you can use to interact
        -- with nvim-treesitter. You should go explore a few and see what interests you:
        --
        --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
        --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
        --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    },
    {
        'akinsho/toggleterm.nvim',
        version = '*',
        config = function()
            require('toggleterm').setup {
                open_mapping = [[<C-\>]],
                direction = 'horizontal',
                size = 15,
            }

            -- Toggle default horizontal terminal
            vim.keymap.set('n', '<leader>m', function()
                vim.cmd 'ToggleTerm'
            end, { desc = '[M]ake - toggle terminal (horizontal)' })

            -- Toggle float terminal
            vim.keymap.set('n', '<leader>tf', function()
                vim.cmd 'ToggleTerm direction=float'
            end, { desc = '[T]oggle terminal [F]loat' })

            -- Toggle vertical terminal
            vim.keymap.set('n', '<leader>tv', function()
                vim.cmd 'ToggleTerm direction=vertical size=80'
            end, { desc = '[T]oggle terminal [V]ertical' })
        end,
    },

    -- Terminal fzf integration - same fzf experience as terminal
    {
        'junegunn/fzf',
        build = function()
            vim.fn['fzf#install']()
        end,
    },
    {
        'junegunn/fzf.vim',
        dependencies = { 'junegunn/fzf' },
        config = function()
            -- Use terminal-style fzf window
            vim.g.fzf_layout = { window = { width = 0.9, height = 0.6 } }

            -- Simple keybinding for quick file access
            vim.keymap.set('n', '<C-p>', ':Files<CR>', { desc = 'Fzf Files' })
            vim.keymap.set('n', '<leader>z', ':Files<CR>', { desc = 'Fzf Files' })
        end,
    },

    -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
    -- init.lua. If you want these files, they are in the repository, so you can just download them and
    -- place them in the correct locations.

    -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
    --
    --  Here are some example plugins that I've included in the Kickstart repository.
    --  Uncomment any of the lines below to enable them (you will need to restart nvim).
    --
    require 'kickstart.plugins.debug',
    require 'kickstart.plugins.indent_line',
    require 'kickstart.plugins.lint',
    require 'kickstart.plugins.autopairs',
    require 'kickstart.plugins.neo-tree',
    require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

    -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
    --    This is the easiest way to modularize your config.
    --
    --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
    -- { import = 'custom.plugins' },
    --
    -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
    -- Or use telescope!
    -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
    -- you can continue same window with `<space>sr` which resumes last telescope search
    --
}, {
    ui = {
        -- If you are using a Nerd Font: set icons to an empty table which will use the
        -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
        icons = vim.g.have_nerd_font and {} or {
            cmd = '⌘',
            config = '🛠',
            event = '📅',
            ft = '📂',
            init = '⚙',
            keys = '🗝',
            plugin = '🔌',
            runtime = '💻',
            require = '🌙',
            source = '📄',
            start = '🚀',
            task = '📌',
            lazy = '💤 ',
        },
    },
})
