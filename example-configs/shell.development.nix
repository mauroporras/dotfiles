let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.05";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShellNoCC {
  packages = with pkgs; [
    cowsay
    go
    go-task
    hello
    lolcat
    wget
  ];

  GREETING = "Using Development";

  shellHook = ''
    echo $GREETING | cowsay | lolcat
  '';
}
