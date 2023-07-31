with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  name = "ava-chamaleon";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "alexvanaxe107";
    repo = "dotfile20";
    rev = "nix_pack";

    sha256 = "sha256-ih0AerJ3hu5Ltzqh/lDWfc6JDFc2Yu96TXagFJm5hPI=";
  };

  builder = "${bash}/bin/bash";
  args = [ "${src}/builder.sh" ];
#  args = [ ./builder.sh ];

  baseInputs = [ coreutils binutils.bintools ];

  meta = with lib; {
    description = "The files for the desktop enviromnetn";
    license = licenses.mit;
    maintainers = with maintainers; [ "alexvanaxe107" ];
    platforms = platforms.all;
  };
}

