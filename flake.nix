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
      }
    );
}
