return {
    "mfussenegger/nvim-dap",
    dependencies = {
        'rcarriga/nvim-dap-ui',
        'nvim-neotest/nvim-nio'

    },
    config = function()
        local dap, dapui = require("dap"), require("dapui")
        dapui.setup()
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end
        vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, {})
        vim.keymap.set('n', '<leader>dc', dap.continue, {})
        vim.keymap.set('n', '<leader>ds', dap.step_over, {})
        vim.keymap.set('n', '<leader>di', dap.step_into, {})

        -- C++/Rust
        dap.adapters.codelldb = {
            type = 'server',
            host = '127.0.0.1',
            port = 13000 -- 💀 Use the port printed out or specified with `--port`
        }
        dap.adapters.codelldb = {
            type = 'server',
            port = "${port}",
            executable = {
                -- CHANGE THIS to your path!
                command = vim.fn.expand('$HOME/.local/bin/codelldb/extension/adapter/codelldb'),
                args = { "--port", "${port}" },

                -- On windows you may have to uncomment this:
                -- detached = false,
            }
        }

        dap.configurations.cpp = {
            {
                name = "Launch file",
                type = "codelldb",
                request = "launch",
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
            },
        }
        dap.configurations.c = dap.configurations.cpp
        dap.configurations.rust = dap.configurations.cpp
        -- CSharp

        dap.adapters.coreclr = {
            type = 'executable',
            command = '/usr/local/netcoredbg',
            args = { '--interpreter=vscode' }
        }
        dap.configurations.cs = {
            {
                type = "coreclr",
                name = "launch - netcoredbg",
                request = "launch",
                program = function()
                    return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
                end,
            },
        }

        -- Python
        dap.adapters.python = function(cb, config)
            if config.request == 'attach' then
                ---@diagnostic disable-next-line: undefined-field
                local port = (config.connect or config).port
                ---@diagnostic disable-next-line: undefined-field
                local host = (config.connect or config).host or '127.0.0.1'
                cb({
                    type = 'server',
                    port = assert(port, '`connect.port` is required for a python `attach` configuration'),
                    host = host,
                    options = {
                        source_filetype = 'python',
                    },
                })
            else
                cb({
                    type = 'executable',
                    command = '/opt/debugpy/venv/bin/python3',
                    args = { '-m', 'debugpy.adapter' },
                    options = {
                        source_filetype = 'python',
                    },
                })
            end
        end
        local dap = require('dap')
        dap.configurations.python = {
            {
                -- The first three options are required by nvim-dap
                type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
                request = 'launch',
                name = "Launch file",

                -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

                program = "${file}", -- This configuration will launch the current file if used.
                pythonPath = function()
                    -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
                    -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
                    -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
                    local cwd = vim.fn.getcwd()
                    if vim.fn.executable(cwd .. '/venv/bin/python3') == 1 then
                        return cwd .. '/venv/bin/python3'
                    elseif vim.fn.executable(cwd .. '/.venv/bin/python3') == 1 then
                        return cwd .. '/.venv/bin/python3'
                    else
                        return '/usr/bin/python3'
                    end
                end,
            },
        }
    end
}
