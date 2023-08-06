{
  description = "Home Manager configuration of alexvanaxe";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    avabible.url = "github:alexvanaxe107/biblia/master";
    avadmenu = {
           url = "github:alexvanaxe107/ava_dmenu/master";
       };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."alexvanaxe" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.

        extraSpecialArgs = { inherit (inputs) unstable avadmenu avabible; inherit system; };
        modules = [ ./home.nix
                    ./ava.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}