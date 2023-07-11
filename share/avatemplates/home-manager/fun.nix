{ pkgs, ... }:

{
    home.packages = [ 
        pkgs.steam
        pkgs.gamescope
        pkgs.openbox
        pkgs.fzf
        pkgs.gamemode
    ];
}
