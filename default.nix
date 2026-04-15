{
  pkgs ? import <nixpkgs> { },
}:
{
  extraConfigLua = ''
    local statusline = require("mini.statusline")
    statusline.section_mode = function() return "" end

    statusline.section_filename = function()
      return vim.fn.expand("%:t") -- File name with extension
    end

    statusline.section_location = function()
      return "%2l:%-2v"
    end

    -- see: `signcolumn`
    function show_only_one_sign_in_sign_column()

      local filter_diagnostics = function(diagnostics)
        if not diagnostics then
          return {}
        end

        -- find the "worst" diagnostic per line
        local most_severe = {}
        for _, cur in pairs(diagnostics) do
          local max = most_severe[cur.lnum]

          -- higher severity has lower value (`:h diagnostic-severity`)
          if not max or cur.severity < max.severity then
            most_severe[cur.lnum] = cur
          end
        end

        -- return list of diagnostics
        return vim.tbl_values(most_severe)
      end

      ---custom namespace
      local ns = vim.api.nvim_create_namespace('severe-diagnostics')

      ---reference to the original handler
      local orig_signs_handler = vim.diagnostic.handlers.signs

      ---Overriden diagnostics signs helper to only show the single most relevant sign
      ---@see `:h diagnostic-handlers`
      vim.diagnostic.handlers.signs = {
        show = function(_, bufnr, _, opts)
          -- get all diagnostics from the whole buffer rather
          -- than just the diagnostics passed to the handler
          local diagnostics = vim.diagnostic.get(bufnr)

          local filtered_diagnostics = filter_diagnostics(diagnostics)

          -- pass the filtered diagnostics (with the
          -- custom namespace) to the original handler
          orig_signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
        end,

        hide = function(_, bufnr)
          orig_signs_handler.hide(ns, bufnr)
        end,
      }

    end
    -- call
    -- TODO: evaluate if this is needed
    -- show_only_one_sign_in_sign_column()

    -- disable underline for warnings
    vim.cmd([[ highlight DiagnosticUnderlineWarn gui=NONE cterm=NONE ]])
  '';

  colorschemes = {
    dracula-nvim = {
      enable = true;
      settings = {
        theme = "dracula-soft";
        colors = {
          bg = "#303030";
        };
        overrides = {
          DiffAdd = {
            fg.__raw = "require('dracula').colors().green";
            bg.__raw = "require('dracula').colors().menu";
          };
          DiffText = {
            fg.__raw = "require('dracula').colors().red";
            bg = "#44475A";
          };
          DiagnosticVirtualTextWarn = {
            fg = "#FFD39E";
          };
          DiagnosticSignWarn = {
            fg = "#FFD39E";
          };
          DiagnosticFloatingWarn = {
            fg = "#FFD39E";
          };
          # TODO the follwing are defauls taken from the dracula theme, need to investigate why they are not working
          Search = {
            fg.__raw = "require('dracula').colors().black";
            bg.__raw = "require('dracula').colors().orange";

          };
          IncSearch = {
            fg.__raw = "require('dracula').colors().orange";
            bg.__raw = "require('dracula').colors().comment";
          };
        };
      };
    };
  };

  globals = {
    mapleader = " ";
    maplocalleader = " ";

    have_nerd_font = false;

    # disable netrw
    loaded_netrw = 1;
    loaded_netrwPlugin = 1;
  };

  opts = {
    # Enable hybrid line numbers
    number = true;
    relativenumber = true;

    # Disable mouse mode
    mouse = "";

    # Don't show the mode, since it's already in the statusline
    showmode = false;

    clipboard = {
      providers = {
        wl-copy.enable = true; # For Wayland
        xsel.enable = true; # For X11
      };
    };

    breakindent = true;

    undofile = true;

    # Case-insensitive searching UNLESS \C or one or more capital letters in search term
    ignorecase = true;
    smartcase = true;

    # This allows gitsigns and diagnostic signs to co-exist in the sign column
    signcolumn = "auto:2";

    # Decrease update time
    updatetime = 250;

    # Decrease mapped sequence wait time
    timeoutlen = 300;

    # Configure how new splits should be opened
    splitright = true;
    splitbelow = true;

    list = true;
    listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";

    # Preview substitutions live, as you type!
    inccommand = "split";

    cursorline = true;

    scrolloff = 10;

    # show only one status line on splits
    laststatus = 3;

    confirm = true;

    # Set blinking cursor
    guicursor = "a:blinkon100";

    spelllang = "en_us";
    spell = false;

    # hover windows rounded borders
    winborder = "rounded";
  };

  keymaps = (import ./keymaps.nix).keymaps;

  autoGroups = {
    kickstart-highlight-yank = {
      clear = true;
    };

    kickstart-lsp-attach = {
      clear = true;
    };

    lint = {
      clear = true;
    };

    InsertModeColors = {
      clear = true;
    };

    ChangeCursorShape = {
      clear = true;
    };
  };

  diagnostic.settings = {
    update_in_insert = false;

    severity_sort = true;
    float = {
      border = "rounded";
      spacing = 2;
      source = "if_many";
    };

    jump = {
      float = true;
    };

    virtual_text = true;
    virtual_lines = false;
  };

  editorconfig.enable = true;

  autoCmd = [
    {
      event = [ "TextYankPost" ];
      desc = "Highlight when yanking (copying) text";
      group = "kickstart-highlight-yank";
      callback.__raw = ''
        function()
          vim.highlight.on_yank()
        end
      '';
    }

    # Change the background color when switching modes
    {
      event = [ "InsertEnter" ];
      desc = "Change the background color to dark when going to insert mode";
      group = "InsertModeColors";
      callback.__raw = ''
        function()
          vim.api.nvim_set_hl(0, 'Normal', { bg = '#191A21', ctermbg = 'black' })
        end
      '';
    }
    {
      event = [ "InsertLeave" ];
      desc = "Change the background color to the scheme one when going to normal mode";
      group = "InsertModeColors";
      callback.__raw = ''
        function()
          vim.api.nvim_set_hl(0, 'Normal', { bg = '#303030', ctermbg = 'NONE' })
        end
      '';
    }

    # Change the cursor shape when switching modes
    {
      event = [ "InsertEnter" ];
      desc = "Change the cursor shape when going to insert mode";
      group = "ChangeCursorShape";
      callback.__raw = ''
        function()
          vim.o.guicursor = 'a:ver25'
        end
      '';
    }
    {
      event = [ "InsertLeave" ];
      desc = "Change the cursor shape when going to normal mode";
      group = "ChangeCursorShape";
      callback.__raw = ''
        function()
          vim.o.guicursor = 'a:blinkon100'
        end
      '';
    }
  ];

  lsp = (import ./lsp.nix { inherit pkgs; }).lsp;

  plugins = (import ./plugins.nix { inherit pkgs; }).plugins;

  extraPlugins = (import ./plugins.nix { inherit pkgs; }).extraPlugins;
}
