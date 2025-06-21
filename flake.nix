{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        tools = with pkgs; [
          tmux
          charm-freeze
          fish
          inkscape
          fontconfig
          nerd-fonts.jetbrains-mono
        ];
      in
      {
        devShells = {
          default = pkgs.mkShell {
            packages = tools;
            FONTCONFIG_PATH = "${pkgs.fontconfig.out}/etc/fonts";
          };
          start = pkgs.mkShell {
            packages = tools;
            shellHook = ''
              ./start.sh
            '';
          };
        };
        packages = {
          terminal = pkgs.writeShellApplication {
            name = "terminal";
            runtimeInputs = with pkgs; [
              fish
              tmux
            ];
            text = ''
              tmux new-session 'fish --init-command="function fish_prompt; echo '"'"'\$'" '"'; end"'
            '';
          };
          # Takes screenshots of the terminal instance
          # usage: capture -o output.svg
          # TODO: make excluded prompt lines configurable here
          capture = pkgs.writeShellApplication {
            name = "capture";
            runtimeInputs = tools;
            runtimeEnv.FONTCONFIG_PATH = "${pkgs.fontconfig}/etc/fonts";
            text = ''
              tmux capture-pane -pet 0 | freeze -c ${self}/freeze.json "$@"
            '';
          };
        };
      }
    );
}
