{
  description = "a nix template for node project dev";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};

    nodejs = pkgs.nodejs; # specify node version here
  in {
    devShells."${system}".default = pkgs.mkShell {
      buildInputs =
        [
          nodejs
        ]
        ++ (with pkgs.nodePackages; [
          npm
          yarn
          pnpm
        ])
        ++ (with pkgs; [
          # nix formatter
          alejandra

          # use vs-codium as ide
          (vscode-with-extensions.override {
            vscode = vscodium;

            vscodeExtensions = with vscode-extensions; [
              # language pack
              ms-ceintl.vscode-language-pack-zh-hant

              # for nix
              bbenoist.nix
              vscode-extensions.kamadorueda.alejandra

              # for js
              esbenp.prettier-vscode
            ];
          })
        ]);
    };
  };
}
