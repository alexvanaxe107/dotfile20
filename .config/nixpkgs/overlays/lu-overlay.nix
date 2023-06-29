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

  userPackages = super.userPackages or {} // {

    # Example:
    # hello = self.hello;
    # add more packages here...
    python3 = self.python3.withPackages (ps: [
	 ps.pygobject3 ps.pydbus ps.click ps.i3ipc]);
    bspwm = self.bspwm;
    tmux = self.tmux;
    zsh = self.zsh;
    neovim = self.neovim;
    sxhkd = self.sxhkd;
    dunst = self.dunst;
    polybar = self.polybar;
    nitrogen = self.nitrogen;

    # media
    yt-dlp = self.yt-dlp;
    sxiv = self.sxiv;
    imagemagick = self.imagemagick;
    # picom = self.picom;
    playerctl = self.playerctl;
    cli-visualizer = self.cli-visualizer;

    # utilities
    gnome_pomodoro = self.gnome.pomodoro;
    eww = self.eww;
    xclip = self.xclip;
    fzf = self.fzf;
    xsecurelock = self.xsecurelock;
    # programming
    wezterm = self.wezterm;
    unclutter = self.unclutter;

    qutebrowser = self.qutebrowser;
    fd = self.fd;

    # Nicities
    fortune = self.fortune;

    mpv = super.mpv.override {
      scripts = [ self.mpvScripts.mpris ];
    };
    spotify = self.spotify;

    rofi = self.rofi;
    dmenu = (import ~/Documents/Projects/nixconfs/nixconfs/dmenu.nix);
    ava_bible = (import ~/Documents/Projects/nixconfs/nixconfs/ava-bible.nix);
    picom_animations = (import ~/Documents/Projects/nixconfs/nixconfs/picom-animations.nix);


    # Default packages:
    # cacert = self.cacert;
    # nix = self.nix;  # don't enable this on multi-user.

    nix-rebuild = super.writeScriptBin "nix-rebuild" ''
      #!${super.stdenv.shell}
      if ! command -v nix-env &>/dev/null; then
          echo "warning: nix-env was not found in PATH, add nix to userPackages" >&2
          PATH=${self.nix}/bin:$PATH
      fi
      exec nix-env -f '<nixpkgs>' -r -iA userPackages "$@"
    '';

  };
}
