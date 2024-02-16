{
  description = "Home Manager configuration of alexvanaxe";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    # Getting unstable from the registry
    unstable.url = "flake:unstable";

    avabible.url = "github:alexvanaxe107/biblia/master";
    avafonts.url = "github:alexvanaxe107/fonts/master";
    avadmenu = {
           url = "github:alexvanaxe107/ava_dmenu/master";
       };

    avatdm.url = "github:alexvanaxe107/tdm_flakes/main";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
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

        extraSpecialArgs = { inherit (inputs) unstable avadmenu avabible avafonts; inherit system; };
        modules = [ ./home.nix
                    ./ava.nix
                    ./local.nix];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
