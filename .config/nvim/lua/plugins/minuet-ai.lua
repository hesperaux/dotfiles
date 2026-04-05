return {
    {
        'milanglacier/minuet-ai.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'hrsh7th/nvim-cmp',
        },
        config = function() 
            require('minuet').setup {
                provider = 'openai_fim_compatible',
                n_completions = 1,
                context_window = 8192,
                provider_options = {
                    openai_fim_compatible = {
                        api_key = 'ARIA_API_GW_KEY',
                        name = 'Qwen',
                        end_point = 'https://ai.stronghold/gw/v1/completions',
                        model = 'llm-coding',
                        stream = false,
                        optional = {
                            max_tokens = 200,
                            top_p = 0.95,
                            temperature = 0.0,
                            stop = {'\u{FEC2}', '```'},
                        },
                        get_text_fn = {
                            stream = function(json)
                                local text = json.choices[1].delta and json.choices[1].delta.text or ""
                                return text:gsub('\u{FEC0}', ''):gsub('\u{FEC1}', ''):gsub('\u{FEC2}', '')
                            end,
                            no_stream = function(json)
                                local text = json.choices[1].text or ""
                                return text:gsub('\u{FEC0}', ''):gsub('\u{FEC1}', ''):gsub('\u{FEC2}', '')
                            end,
                        },
                        template = {
                            suffix = function(context_before_cursor, context_after_cursor, opts)
                                return '\u{FEC2}' .. context_after_cursor
                            end,
                            prompt = function(context_before_cursor, context_after_cursor, opts)
                                return '\u{FEC0}' .. context_before_cursor .. '\u{FEC1}'
                            end,
                        },
                    },
                },
                cmp = {
                    enable_auto_complete = true,
                },
                virtualtext = {
                    auto_trigger_ft = {},
                },
                debounce = 300,
                throttle = 3000,
            }
        end,
    }
}
