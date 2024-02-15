
{ pkgs, system, unstable, ... }:

{
    nixpkgs.config.allowUnfreePredicate = (pkg: true);
    home.packages = [ 
       pkgs.zeroadPackages.zeroad
       pkgs.zeroadPackages.zeroad-data
       pkgs.gamescope
    ];

}
