{
  description = "The desktop files";

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.default = ./ava-chamaleon.nix;

  };
}
