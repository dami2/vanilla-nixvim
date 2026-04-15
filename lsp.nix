{
  pkgs ? import <nixpkgs> { },
}:
{
  lsp = {

    # This function gets run when an LSP attaches to a particular buffer.
    #   That is to say, every time a new file is opened that is associated with
    #   an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
    #   function will be executed to configure the current buffer
    onAttach = builtins.readFile ./on-lsp-attach.lua;

    keymaps = [

      # Rename the variable under your cursor.
      #  Most Language Servers support renaming across files, etc.
      {
        key = "grn";
        lspBufAction = "rename";
        options = {
          desc = "LSP: [R]e[n]ame";
        };
      }

      # Execute a code action, usually your cursor needs to be on top of an error
      # or a suggestion from your LSP for this to activate.
      {
        key = "gra";
        lspBufAction = "code_action";
        mode = [
          "n"
          "x"
        ];
        options = {
          desc = "LSP: [C]ode [A]ction";
        };
      }

      # WARN: This is not Goto Definition, this is Goto Declaration.
      #  For example, in C this would take you to the header.
      {
        key = "grD";
        lspBufAction = "declaration";

        options = {
          desc = "LSP: [G]oto [D]eclaration";
        };
      }
    ];

    servers = {
      "*" = {
        config = {
          capabilities = {
            textDocument = {
              semanticTokens = {
                multilineTokenSupport = true;
              };
            };
          };
          root_markers = [
            ".git"
          ];
        };
      };

      marksman = {
        enable = true;
        config = {
          cmd = [
            "marksman"
            "server"
          ];
          filetypes = [
            "markdown"
          ];
        };
      };

    };
  };
}
