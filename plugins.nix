{
  pkgs ? import <nixpkgs> { },
}:
{
  plugins = {
    # Adds icons for plugins to utilize in ui
    web-devicons.enable = false;

    # Detect tabstop and shiftwidth automatically
    sleuth = {
      enable = true;
    };

    luasnip = {
      enable = true;
    };

    # Adds git related signs to the gutter, as well as utilities for managing changes
    gitsigns = {
      enable = true;
      settings = {
        signs = {
          add = {
            text = "+";
          };
          change = {
            text = "~";
          };
          delete = {
            text = "_";
          };
          topdelete = {
            text = "‾";
          };
          changedelete = {
            text = "~";
          };
        };
      };
    };

    # Useful plugin to show you pending keybinds.
    which-key = {
      enable = true;

      settings = {
        delay = 0;
        icons = {
          mappings = false;
        };
        spec = [
          {
            __unkeyed-1 = "<leader>c";
            group = "[C]ode";
          }
          {
            __unkeyed-1 = "<leader>d";
            group = "[D]ocument";
          }
          {
            __unkeyed-1 = "<leader>r";
            group = "[R]ename";
          }
          {
            __unkeyed-1 = "<leader>s";
            group = "[S]earch";
          }
          {
            __unkeyed-1 = "<leader>w";
            group = "[W]orkspace";
          }
          {
            __unkeyed-1 = "<leader>t";
            group = "[T]oggle";
          }
          {
            __unkeyed-1 = "<leader>h";
            group = "Git [H]unk";
            mode = [
              "n"
              "v"
            ];
          }
          {
            __unkeyed-1 = "gr";
            group = "LSP Actions";
            mode = [ "n" ];

          }
        ];
      };
    };

    fzf-lua = {
      enable = true;
      settings = {
        winopts = {
          fullscreen = true;
          border = "none";
          preview = {
            layout = "vertical";
            vertical = "down:45%";
          };
        };
        files = {
          file_icons = false;
        };
      };
    };

    # Useful status updates for LSP.
    fidget = {
      enable = true;
    };

    # Autoformat
    conform-nvim = {
      enable = true;
      settings = {
        notify_on_error = false;
        format_on_save.__raw = ''
          function(bufnr)
            -- Disable "format_on_save lsp_fallback" for languages that don't
            -- have a well standardized coding style. You can add additional
            -- languages here or re-enable it for the disabled ones.
            local disable_filetypes = { c = true, cpp = true }
            if disable_filetypes[vim.bo[bufnr].filetype] then
              return nil
            else
              return {
                timeout_ms = 500,
                lsp_format = 'fallback',
              }
            end
          end
        '';

        formatters_by_ft = {
          # Use the "*" filetype to run formatters on all filetypes.
          "*" = [
            "squeeze_blanks"
            "trim_whitespace"
            "trim_newlines"
          ];
          # Use the "_" filetype to run formatters on filetypes that don't have other formatters configured.
          "_" = [
            "squeeze_blanks"
            "trim_whitespace"
            "trim_newlines"
          ];

        };
      };
    };

    # Highlight todo, notes, etc in comments
    todo-comments = {
      enable = true;
      settings = {
        signs = false;
      };
    };

    mini = {
      enable = true;

      mockDevIcons = false;
      modules = {
        ai = {
          n_lines = 500;
        };

        surround = { };

        statusline = {
          use_icons = false;
        };

        comment = {
          mappings = {
            comment = "<leader>/";
            comment_line = "<leader>/";
            comment_visual = "<leader>/";
            textobject = "<leader>/";
          };
        };
        diff = {
          view = {
            style = "sign";
          };
        };
      };
    };

    treesitter = {
      enable = true;

      settings = {
        ensureInstalled = [
          "bash"
          "c"
          "diff"
          "html"
          "lua"
          "luadoc"
          "markdown"
          "markdown_inline"
          "query"
          "vim"
          "vimdoc"
        ];
        auto_install = true;

        highlight = {
          enable = true;

          additional_vim_regex_highlighting = [ "ruby" ];
        };

        indent = {
          enable = true;
          disable = [ "ruby" ];
        };
      };
    };

    # Add indentation guides even on blank lines
    indent-blankline = {
      enable = true;
      settings = {
        exclude = {
          buftypes = [
            "terminal"
            "quickfix"
          ];
          filetypes = [
            ""
            "checkhealth"
            "help"
            "lspinfo"
            "packer"
            "TelescopePrompt"
            "TelescopeResults"
            "yaml"
          ];
        };
        indent = {
          char = "┊";
        };
        debounce = 500;
        scope = {
          show_end = false;
          show_exact_scope = true;
          show_start = false;
        };
      };

    };

    lint = {
      enable = true;

      lintersByFt = {
        # nix = [ "nixd" ];
      };

      autoCmd = {
        callback.__raw = ''
          function()
            if vim.opt_local.modifiable:get() then
              require('lint').try_lint()
            end
          end
        '';
        group = "lint";
        event = [
          "BufEnter"
          "BufWritePost"
          "InsertLeave"
        ];
      };
    };

    fugitive = {
      enable = true;
    };

    oil = {
      enable = true;
      settings = {
        default_file_explorer = true;
        keymaps = {
          "." = "actions.cd";
          "<C-r>" = "actions.refresh";
          "<leader>qq" = "actions.close";
          "<C-h>" = false;
        };
        columns = [
          {
            __unkeyed = "size";
            highlight = "Special";
          }
        ];
      };
    };

    nvim-bqf = {
      enable = true;
    };

    hardtime = {
      enable = true;
    };

    precognition = {
      enable = true;
    };

    snacks = {
      enable = true;
      settings = {
        bigfile = {
          enabled = true;
        };
        dashboard = {
          enabled = false;
        };
        explorer = {
          enabled = false;
        };
        indent = {
          enabled = false;
        };
        input = {
          enabled = false;
        };
        picker = {
          enabled = false;
        };
        notifier = {
          enabled = false;
        };
        quickfile = {
          enabled = true;
        };
        scope = {
          enabled = false;
        };
        scroll = {
          enabled = true;
        };
        statuscolumn = {
          enabled = false;
        };
        words = {
          enabled = false;
        };
      };
    };

    smartcolumn = {
      enable = true;
      settings = {
        disabled_filetypes = [ "help" ];
      };
    };

    # Required for eslint to work correctly with its default settings
    lsp = {
      enable = true;
    };
  };

  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "vim-abolish";
      src = pkgs.fetchFromGitHub {
        owner = "tpope";
        repo = "vim-abolish";
        rev = "880a562";
        hash = "sha256-RpWgs4aIfbd3XoMGwcuLb+K6DavIgiQ7nG7yxRKipEU=";
      };
    })
  ];
}
