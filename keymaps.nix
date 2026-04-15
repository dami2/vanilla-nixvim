{
  keymaps = [
    # Clear highlights on search when pressing <Esc> in normal mode
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
    }

    # Diagnostic
    {
      mode = "n";
      key = "<leader>e";
      action.__raw = "vim.diagnostic.open_float";
      options = {
        desc = "Op[E]n floating diagnostic message";
      };
    }

    {
      mode = "n";
      key = "<leader>q";
      action.__raw = "vim.diagnostic.setloclist";
      options = {
        desc = "Open diagnostic [Q]uickfix list";
      };
    }

    # Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
    # for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
    # is not what someone will guess without a bit more experience.
    #
    # NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
    # or just use <C-\><C-n> to exit terminal mode
    {
      mode = "t";
      key = "<Esc><Esc>";
      action = "<C-\\><C-n>";
      options = {
        desc = "Exit terminal mode";
      };
    }

    # Keybinds to make split navigation easier.
    #  Use CTRL+<hjkl> to switch between windows
    #
    #  See `:help wincmd` for a list of all window commands
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w><C-h>";
      options = {
        desc = "Move focus to the left window";
      };
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w><C-l>";
      options = {
        desc = "Move focus to the right window";
      };
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w><C-j>";
      options = {
        desc = "Move focus to the lower window";
      };
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w><C-k>";
      options = {
        desc = "Move focus to the upper window";
      };
    }

    # FZF Lua Mappings
    {
      mode = "n";
      key = "<leader>z";
      action = "<cmd>FzfLua<CR>";
      options = {
        desc = "Open LUA F[Z]F";
      };
    }
    {
      mode = "n";
      key = "<leader>?";
      action = "<cmd>FzfLua oldfiles<CR>";
      options = {
        desc = "[?] Find recently opened files";
      };
    }
    {
      mode = "n";
      key = "<leader>sh";
      action = "<cmd>FzfLua helptags<CR>";
      options = {
        desc = "[S]earch [H]elp";
      };
    }
    {
      mode = "n";
      key = "<leader>sk";
      action = "<cmd>FzfLua keymaps<CR>";
      options = {
        desc = "[S]earch [K]eymaps";
      };
    }
    {
      mode = "n";
      key = "<leader>sf";
      action = "<cmd>FzfLua files<CR>";
      options = {
        desc = "[S]earch [F]iles";
      };
    }
    {
      mode = "n";
      key = "<leader>sd";
      action = "<cmd>FzfLua diagnostics_document<CR>";
      options = {
        desc = "[S]earch [D]iagnostics";
      };
    }
    {
      mode = "n";
      key = "<leader>sg";
      action.__raw = ''
        function()
          require('fzf-lua').live_grep({
            rg_opts = "--glob '!*.{test,spec}'"
          })
        end
      '';
      options = {
        desc = "[S]earch by [G]rep (excluding test files)";
      };
    }
    {
      mode = "n";
      key = "<leader>sr";
      action = "<cmd>FzfLua live_grep<CR>";
      options = {
        desc = "[S]earch by g[R]ep (including test files)";
      };
    }

    {
      mode = "n";
      key = "<leader>sa";
      action.__raw = ''
        function()
          local query = vim.fn.input("Ast-grep query: ")
          require('fzf-lua').fzf_exec(
            "ast-grep --context 0 --heading never --pattern '" .. query .. "' 2> /dev/null",
            {
              exec_empty_query = false,
              actions = {
                ['default'] = require "fzf-lua".actions.file_edit,
              },
              previewer = 'builtin'
            }
          )
        end
      '';
      options = {
        desc = "[S]earch by [A]st-grep";
      };
    }

    {
      mode = "n";
      key = "<leader><leader>";
      action = "<cmd>FzfLua buffers<CR>";
      options = {
        desc = "[ ] Find existing buffers";
      };
    }
    {
      mode = "n";
      key = "<leader>sq";
      action = "<cmd>FzfLua quickfix<CR>";
      options = {
        desc = "Find [Q]uick list";
      };
    }
    # Commands
    {
      mode = "n";
      key = "<leader>sc";
      action = "<cmd>FzfLua commands<CR>";
      options = {
        desc = "[S]earch [C]ommands";
      };
    }
    {
      mode = "n";
      key = "<leader>sm";
      action = "<cmd>FzfLua git_commits<CR>";
      options = {
        desc = "[S]earch co[M]mits";
      };
    }
    {
      mode = "n";
      key = "<leader>su";
      action = "<cmd>FzfLua git_status<CR>";
      options = {
        desc = "[S]earch git stat[U]s";
      };
    }
    {
      mode = "n";
      key = "<leader>st";
      action = "<cmd>FzfLua git_stash<CR>";
      options = {
        desc = "[S]earch git s[T]ash";
      };
    }
    {
      mode = "n";
      key = "<leader>ss";
      action = "<cmd>FzfLua colorschemes<CR>";
      options = {
        desc = "Search color [S]chemes";
      };
    }

    # LSP Mappings

    # Jump to the definition of the word under your cusor.
    #  This is where a variable was first declared, or where a function is defined, etc.
    #  To jump back, press <C-t>.
    {
      mode = "n";
      key = "grd";
      action.__raw = "require('fzf-lua').lsp_definitions";
      options = {
        desc = "LSP: [G]oto [D]definition";
      };
    }

    # Find references for the word under your cursor.
    {
      key = "grr";
      action.__raw = "require('fzf-lua').lsp_references";
      options = {
        desc = "LSP: [G]oto [R]eferences";
      };
    }

    # Jump to the implementation of the word under your cursor.
    #  Useful when your language has ways of declaring types without an actual implementation.
    {
      key = "gri";
      action.__raw = "require('fzf-lua').lsp_implementations";
      options = {
        desc = "LSP: [G]oto [I]mplementation";
      };
    }

    # Jump to the type of the word under your cursor.
    #  Useful when you're not sure what type a variable is and you want to see
    #  the definition of its *type*, not where it was *defined*.
    {
      mode = "n";
      key = "<leader>D";
      action.__raw = "require('fzf-lua').lsp_typedefs";
      options = {
        desc = "LSP: Type [D]definition";
      };
    }

    # Fuzzy find all the symbols in your current document.
    #  Symbols are things like variables, functions, types, etc.
    {
      key = "g0";
      action.__raw = "require('fzf-lua').lsp_document_symbols";
      options = {
        desc = "LSP: [D]ocument [S]symbols";
      };
    }

    # Fuzzy find all the symbols in your current workspace.
    #  Similar to document symbols, except searches over your entire project.
    {
      key = "gW";
      action.__raw = "require('fzf-lua').lsp_workspace_symbols";
      options = {
        desc = "LSP: [W]orkspace [S]symbols";
      };
    }

    # Jump to the type of the word under your cursor.
    #  Useful when you're not sure what type a variable is and you want to see
    #  the definition of its *type*, not where it was *defined*.
    {
      key = "grt";
      action.__raw = "require('fzf-lua').lsp_typedefs";
      options = {
        desc = "LSP: [G]oto [T]ype Definition";
      };
    }

    # conform keymaps
    {
      mode = "";
      key = "<leader>f";
      action.__raw = ''
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end
      '';
      options = {
        desc = "[F]ormat buffer";
      };
    }

    # Personal Mappings
    # Mappings for yank to clipboard
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>y";
      action = ''"+y'';
      options = {
        desc = "[y] Yank to clipboard";
      };
    }

    {
      mode = "n";
      key = "<leader>Y";
      action = ''"+Y'';
      options = {
        desc = "[Y] Yank line to clipboard";
      };
    }

    #  Toggle line numbers
    {
      mode = "n";
      key = "<leader>tn";
      action = "<cmd>set invnumber<cr>";
      options = {
        desc = "[ti] toggle line numbers";
      };
    }

    # Toggle relative line numbers
    {
      mode = "n";
      key = "<leader>tr";
      action = "<cmd>set invrelativenumber<cr>";
      options = {
        desc = "[ti] Toggle relatie line numbers";
      };
    }

    # Mappings for buffers
    {
      mode = "n";
      key = "<leader>bca";
      action = "<cmd>bufdo bdelete<cr>";
      options = {
        desc = "[B]buffers [C]lose [A]ll";
      };
    }
    {
      mode = "n";
      key = "<leader>bco";
      action = "<cmd>%bd|e#<cr>";
      options = {
        desc = "[B]buffers [C]lose [O]thers";
      };
    }

    {
      mode = "n";
      key = "<leader>bn";
      action = "<cmd>bnext<cr>";
      options = {
        desc = "[B]buffers [N]ext";
      };
    }

    {
      mode = "n";
      key = "<leader>bp";
      action = "<cmd>bprev<cr>";
      options = {
        desc = "[B]buffers [P]revious";
      };
    }

    {
      mode = "n";
      key = "<leader>bd";
      action = "<cmd>bd<cr>";
      options = {
        desc = "[B]buffer [D]elete";
      };
    }

    {
      key = "<leader>br";
      action = "<cmd>e<cr>";
      options = {
        desc = "[B]uffer [R]efresh";
      };
    }

    # Keep cursor in position after joining lines
    {
      mode = "n";
      key = "J";
      action = "mzJ`z";
    }

    # Center view after moving
    {
      mode = "n";
      key = "<C-d>";
      action = "<C-d>zz";
    }
    {
      mode = "n";
      key = "<C-u>";
      action = "<C-u>zz";
    }

    # Center view on search
    {
      mode = "n";
      key = "n";
      action = "nzzzv";
    }
    {
      mode = "n";
      key = "N";
      action = "Nzzzv";
    }

    # Move selected lines
    {
      mode = "v";
      key = "J";
      action = ":m '>+1<CR>gv=gv";
    }
    {
      mode = "v";
      key = "K";
      action = ":m '<-2<CR>gv=gv";
    }

    # Widow arrangement
    {
      mode = "n";
      key = "<leader>wh";
      action = "<cmd>wincmd K<cr>";
      options = {
        desc = "Arrange [W]indows [H]orizontaly";
      };
    }
    {
      mode = "n";
      key = "<leader>wv";
      action = "<cmd>wincmd H<cr>";
      options = {
        desc = "Arrange [W]indows [V]erticaly";
      };
    }

    # Copy current buffer file path to clipboard
    {
      mode = "n";
      key = "<leader>cpr";
      action = ''<cmd>let @+=expand("%")<cr>'';
      options = {
        desc = "[C]opy buffer [R]elative file [P]ath";
      };
    }
    {
      mode = "n";
      key = "<leader>cpa";
      action = ''<cmd>let @+=expand("%:p")<cr>'';
      options = {
        desc = "[C]opy buffer [A]bsolute file [P]ath";
      };
    }
    {
      mode = "n";
      key = "<leader>cpf";
      action = ''<cmd>let @+=expand("%:t")<cr>'';
      options = {
        desc = "[C]opy buffer [F]ile name [P]ath";
      };
    }
    {
      mode = "n";
      key = "<leader>cpd";
      action = ''<cmd>let @+=expand("%:p:h")<cr>'';
      options = {
        desc = "[C]opy buffer [D]ir name [P]ath";
      };
    }

    # Map Caps Lock to Escape in Neovim
    {
      # TODO not working
      mode = [
        "n"
        "i"
      ];
      key = "<CapsLock>";
      action = "<Esc>";
      options = {
        noremap = true;
        silent = true;
      };
    }

    # Toggle LSP on/off
    {
      mode = "n";
      key = "<leader>tl";
      action.__raw = ''
        function()
           local original_bufnr = vim.api.nvim_get_current_buf()
           local buf_clients = vim.lsp.get_clients { bufnr = original_bufnr }

           if buf_clients[1] == nil then
             vim.cmd 'LspStart'
           else
             vim.cmd 'LspStop'
           end
         end
      '';
      options = {
        desc = "[tl] Toggle LSP";
      };
    }

    # toggle spell
    {
      mode = "n";
      key = "<leader>ts";
      action = "<cmd>set spell!<cr>";
      options = {
        desc = "[t]oggle [s]pell";
      };
    }

    # Oil mappings
    {
      key = "-";
      action = "<CMD>Oil<CR>";
      options = {
        desc = "Open parent directory";
      };
    }

    # gitsigns mappings
    # Navigation
    {
      mode = "n";
      key = "]c";
      action.__raw = ''
        function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            require('gitsigns').nav_hunk 'next'
          end
        end
      '';
      options = {
        buffer.__raw = "bufnr";
        desc = "Jump to next git [c]hange";
      };
    }

    {
      mode = "n";
      key = "[c";
      action.__raw = ''
        function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            require('gitsigns').nav_hunk 'prev'
          end
        end
      '';
      options = {
        buffer.__raw = "bufnr";
        desc = "Jump to previous git [c]hange";
      };
    }

    # Actions

    #TODO: fix this ones
    # visual mode
    # {
    #   mode = "v";
    #   key = "<leader>hs";
    #   action.__raw = ''
    #     require('gitsigns').stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    #   '';
    #   options = {
    #     buffer.__raw = "bufnr";
    #     desc = "git [s]tage hunk";
    #   };
    # }
    # {
    #   mode = "v";
    #   key = "<leader>hr";
    #   action.__raw = ''
    #     require('gitsigns').reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    #   '';
    #   options = {
    #     buffer.__raw = "bufnr";
    #     desc = "git [r]eset hunk";
    #   };
    # }

    ## normal mode
    {
      mode = "n";
      key = "<leader>hs";
      action.__raw = "require('gitsigns').stage_hunk";
      options = {
        buffer.__raw = "bufnr";
        desc = "git [s]tage hunk";
      };
    }
    {
      mode = "n";
      key = "<leader>hr";
      action.__raw = "require('gitsigns').reset_hunk";
      options = {
        buffer.__raw = "bufnr";
        desc = "git [r]eset hunk";
      };
    }
    {
      mode = "n";
      key = "<leader>hS";
      action.__raw = "require('gitsigns').stage_buffer";
      options = {
        buffer.__raw = "bufnr";
        desc = "git [S]tage buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>hu";
      action.__raw = "require('gitsigns').undo_stage_hunk";
      options = {
        buffer.__raw = "bufnr";
        desc = "git [u]ndo stage hunk";
      };
    }
    {
      mode = "n";
      key = "<leader>hR";
      action.__raw = "require('gitsigns').reset_buffer";
      options = {
        buffer.__raw = "bufnr";
        desc = "git [R]eset buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>hp";
      action.__raw = "require('gitsigns').preview_hunk";
      options = {
        buffer.__raw = "bufnr";
        desc = "git [p]review hunk";
      };
    }
    {
      mode = "n";
      key = "<leader>hb";
      action.__raw = "require('gitsigns').blame_line";
      options = {
        buffer.__raw = "bufnr";
        desc = "git [b]lame line";
      };
    }
    {
      mode = "n";
      key = "<leader>hd";
      action.__raw = "require('gitsigns').diffthis";
      options = {
        buffer.__raw = "bufnr";
        desc = "git [d]iff against index";
      };
    }
    {
      mode = "n";
      key = "<leader>hD";
      action.__raw = ''
        function()
          require('gitsigns').diffthis '@'
        end
      '';
      options = {
        buffer.__raw = "bufnr";
        desc = "git [D]iff against last commit";
      };
    }
    # Toggles
    {
      mode = "n";
      key = "<leader>tb";
      action.__raw = "require('gitsigns').toggle_current_line_blame";
      options = {
        buffer.__raw = "bufnr";
        desc = "[T]oggle git show [b]lame line";
      };
    }
    {
      mode = "n";
      key = "<leader>tD";
      action.__raw = "require('gitsigns').preview_hunk_inline";
      options = {
        buffer.__raw = "bufnr";
        desc = "[T]oggle git show [D]eleted";
      };
    }
  ];
}
