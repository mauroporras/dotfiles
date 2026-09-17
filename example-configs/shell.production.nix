let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.05";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShellNoCC {
  packages = with pkgs; [
    cowsay
    go
    go-task
    lolcat
    wget
  ];

  # Read by the prompt (see misc-configs/starship/starship.toml) to name the
  # environment this directory is wired to. direnv exports it on the way in and
  # drops it on the way out, so the prompt can never name a stale environment.
  # Only "production"/"prod" gets the alarm styling; every other name is
  # treated as safe to break.
  PROJECT_ENV = "production";

  GREETING = "Using Production";

  shellHook = ''
    echo $GREETING | cowsay | lolcat
  '';
}
