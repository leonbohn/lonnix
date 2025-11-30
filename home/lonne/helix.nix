{ pkgs, ... }: {
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "nightfox";
      editor = {
        continue-comments = true;
        true-color = true;
        auto-format = true;
        color-modes = true;
        bufferline = "multiple";

        soft-wrap = {
          enable = true;
          # max-wrap = 30;
          # wrap-at-text-width = true;
        };
        cursor-shape = {
          insert = "underline";
          normal = "block";
          select = "block";
        };
        # statusline = {
        #   right = ["diagnostics" "selections" "position" "position-percentage" "file-encoding"];
        #   center = ["workspace-diagnostics"];
        # };
      };
      keys = {
        normal = {
          "V" = [ "goto_first_nonwhitespace" "extend_to_line_end" ];
          "$" = [ "ensure_selections_forward" "extend_to_line_end" ];
          "x" = "extend_line";
          "C-k" = ":bc";
          "C-s" = [ "normal_mode" ":w" ];
        };
        insert = {
          "C-[" = "normal_mode";
          "C-j" = [ "normal_mode" "open_below" ];
          "C-k" = [ "normal_mode" "open_above" ];
          "C-s" = [ "normal_mode" ":w" ];
        };
        select = { ";" = [ "collapse_selection" "normal_mode" ]; };
      };
    };
    languages.language = [{
      name = "nix";
      auto-format = true;
      formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
    }];
  };
}
