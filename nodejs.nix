{
  description = "a nix template for node project dev";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    devShells."${system}".default = pkgs.mkShell {
      buildInputs = with pkgs.nodePackages;
        [
          nodejs # change it to specific version if necessary

          npm
          yarn
          pnpm
        ]
        ++ (with pkgs; [
          # use vscodium as ide, delete it if not necessary
          (vscode-with-extensions.override {
            vscode = vscodium;

            vscodeExtensions = with vscode-extensions; [
              ms-ceintl.vscode-language-pack-zh-hant

              bbenoist.nix
              vscode-extensions.kamadorueda.alejandra

              esbenp.prettier-vscode
            ];
          })
        ]);
    };
  };
}
