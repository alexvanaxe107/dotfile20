{ pkgs, system, unstable, ... }:

{
    nixpkgs.config.allowUnfreePredicate = (pkg: true);

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    programs.steam = {
      enable = true;
    };

    programs.java.enable = true; 
    programs.steam.gamescopeSession.enable = true;

    home.packages = [ 
        pkgs.openbox
    ];
}

