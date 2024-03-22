{ pkgs, system, unstable, ... }:

{
    nixpkgs.config.allowUnfreePredicate = (pkg: true);

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    programs.java.enable = true; 

    home.packages = [ 
        pkgs.openbox
        pkgs.fzf
        pkgs.google-chrome
        pkgs.onlyoffice-bin
        pkgs.vmware-horizon-client
    ];
}

