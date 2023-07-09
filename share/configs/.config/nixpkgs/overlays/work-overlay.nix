self: super:
{
  # Install overlay:
  # $ mkdir -p ~/.config/nixpkgs/overlays
  # Run: nix-env -f '<nixpkgs>' -r -iA userPackages
  # After that just call nix-rebuild to implement the updates.
  # Look at more ideas on this pages:
  # https://gist.github.com/LnL7/570349866bb69467d0caf5cb175faa74
  # https://discourse.nixos.org/t/declarative-package-management-for-normal-users/1823
  # $ curl https://gist.githubusercontent.com/LnL7/570349866bb69467d0caf5cb175faa74/raw/3f3d53fe8e8713ee321ee894ecf76edbcb0b3711/lnl-overlay.nix -o ~/.config/nixpkgs/overlays/lnl.nix

  workPackages = super.workPackages or {} // {

    # Example:
    # hello = self.hello;
    # add more packages here...

    google-chrome = self.google-chrome;
    vmware-horizon-client = self.vmware-horizon-client;

    # Default packages:
    # cacert = self.cacert;
    # nix = self.nix;  # don't enable this on multi-user.

    nix-rebuild = super.writeScriptBin "nix-rebuild" ''
      #!${super.stdenv.shell}
      if ! command -v nix-env &>/dev/null; then
          echo "warning: nix-env was not found in PATH, add nix to workPackages" >&2
          PATH=${self.nix}/bin:$PATH
      fi
      exec nix-env -f '<nixpkgs>' -r -iA workPackages "$@"
    '';

  };
}
