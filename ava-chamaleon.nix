{ pkgs }:
pkgs.stdenv.mkDerivation rec {
  name = "ava-chamaleon";
  version = "0.7.2";

  src = pkgs.fetchFromGitHub {
    owner = "alexvanaxe107";
    repo = "dotfile20";
    rev = "nix_pack";

    sha256 = "sha256-Y0SU9zoRGcYi/UTc10lqbJa090NIsefCGCVSS+adV3I=";
  };

  builder = "${pkgs.bash}/bin/bash";
  args = [ "${src}/builder.sh" ];
#  args = [ ./builder.sh ];

  baseInputs = [ pkgs.coreutils pkgs.binutils.bintools ];

  meta = with pkgs.lib; {
    description = "The files for the desktop enviromnetn";
    license = licenses.mit;
    maintainers = with maintainers; [ "alexvanaxe107" ];
    platforms = platforms.all;
  };
}

