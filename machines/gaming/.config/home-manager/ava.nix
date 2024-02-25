{ pkgs, system, unstable, ... }:

{
    nixpkgs.config.allowUnfreePredicate = (pkg: true);

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    programs.java.enable = true; 

    home.packages = [ 
        pkgs.openbox
        pkgs.steam
        pkgs.fzf
        pkgs.gamescope
        pkgs.gamemoderun 
    ];
}

