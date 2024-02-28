{ pkgs, system, unstable, ... }:

{
    nixpkgs.config.allowUnfreePredicate = (pkg: true);

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    programs.java.enable = true; 

    home.packages = [ 
        pkgs.openbox
        (pkgs.steam.override {
          extraPkgs = pkgs: with pkgs; [ pango harfbuzz libthai ];
        })
        pkgs.fzf
        pkgs.gamescope
        pkgs.gamemode
        pkgs.protonup-ng
    ];
}

