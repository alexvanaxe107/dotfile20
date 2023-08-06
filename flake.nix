{
  description = "The desktop files";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-23.05;

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.default = 
    with import nixpkgs { system = "x86_64-linux"; };
    stdenv.mkDerivation rec {
      name = "ava-chamaleon";
      version = "0.7.2";

      src = self;


      builder = "${bash}/bin/bash";
      args = [ "${src}/builder.sh" ];
#  args = [ ./builder.sh ];

      baseInputs = [ coreutils ];

      meta = with lib; {
        description = "The files for the desktop enviromnetn";
        license = licenses.mit;
        maintainers = with maintainers; [ "alexvanaxe107" ];
      };
    };
};
}