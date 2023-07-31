{
  description = "The desktop files";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-23.05;

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.default = 
    with import nixpkgs { system = "x86_64-linux"; };
    import ./ava-chamaleon.nix {pkgs={inherit stdenv lib fetchFromGitHub coreutils binutils;};};

  };
}
