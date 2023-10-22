{
  description = "a nix template for ml python project dev";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};

    jdk = pkgs.jdk17; # specify jdk version here
    scala = pkgs.scala_3; # specify scala version here
  in {
    devShells."${system}".default = pkgs.mkShell {
      buildInputs =
        [
          jdk
          scala
        ]
        ++ (with pkgs; [
          scala-cli
          sbt
          ammonite
          scalafmt
        ])
        ++ (with pkgs; [
          # nix formatter
          alejandra

          # use vscodium as ide, delete it if not necessary
          (vscode-with-extensions.override {
            vscode = vscodium;

            vscodeExtensions = with vscode-extensions; [
              # language pack
              ms-ceintl.vscode-language-pack-zh-hant

              # for nix
              bbenoist.nix
              kamadorueda.alejandra

              # for scala
              scala-lang.scala
              scalameta.metals
            ];
          })
        ]);
    };
  };
}
