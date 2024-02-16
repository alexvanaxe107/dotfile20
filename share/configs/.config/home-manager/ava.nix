{ pkgs, system, unstable, avadmenu, avabible, avafonts, avatdm, ... }:

{
    nixpkgs.config.allowUnfreePredicate = (pkg: true);
    home.packages = [ 

        # Barebones Changed!
        pkgs.stow

        pkgs.polybar 
        (pkgs.python3.withPackages(ps: [ps.pygobject3 ps.pydbus ps.click ps.i3ipc]))
        pkgs.bspwm
        pkgs.wmctrl
        pkgs.tmux
        pkgs.zsh
        pkgs.sxhkd
        pkgs.dunst
        # polybar = self.polybar;
        pkgs.nitrogen

        # media
        pkgs.yt-dlp
        pkgs.sxiv
        pkgs.imagemagick
        pkgs.picom
        pkgs.playerctl
        pkgs.cli-visualizer
        pkgs.pulseaudio
        pkgs.flameshot

        # Rss News Feed
        pkgs.newsboat
        pkgs.rsstail

        # Communication
        pkgs.gomuks

        # utilities
        pkgs.gnome.pomodoro
        pkgs.eww-wayland
        pkgs.conky
        pkgs.xclip
        pkgs.fzf
        pkgs.xsecurelock
        pkgs.transmission
        # (import <unstable> {}).font-manager
    	pkgs.kcharselect
        # programming
        pkgs.wezterm
        pkgs.st
        pkgs.unclutter
        pkgs.calibre
        pkgs.zathura
        pkgs.foliate

        pkgs.jellyfin

        pkgs.qutebrowser

        pkgs.fd
        pkgs.ripgrep
        pkgs.jq

        # Productivity
        pkgs.todo-txt-cli

        # Nicities
        pkgs.fortune
        pkgs.pywal

        (pkgs.mpv.override {
          scripts = [ pkgs.mpvScripts.mpris ];
        })
        pkgs.spotify

        pkgs.rofi

        pkgs.nerdfonts

        # development
        pkgs.neovim
        pkgs.nodejs
        pkgs.emacs29-gtk3
        # Experimental
        (import unstable {system = "${system}";}).hyprland
        (import unstable {system = "${system}";}).swww
        (import unstable {system = "${system}";}).bemenu
        (import unstable {system = "${system}";}).waybar

        avadmenu.defaultPackage.${system}
        avabible.defaultPackage.${system}
        avafonts.defaultPackage.${system}
        avatdm.tdm




        # Here we will abuse a little and take confort by adding this code Here
        # to avoid the creation of other repo. If it begins to happen a lot (hope not)
        # then I fix it.
        #(pkgs.picom.overrideAttrs (oldAttrs: rec {
        #  pname = "picom-animations";
        #  version = "unstable-2022-08";
        #  src = pkgs.fetchFromGitHub {
        #    owner = "dccsillag";
        #    repo = "picom";
        #    rev = "51b21355696add83f39ccdb8dd82ff5009ba0ae5";
        #    sha256 = "sha256-crCwRJd859DCIC0pEerpDqdX2j8ZrNAzVaSSB3mTPN8=";
        #  };

        #  meta = with pkgs.lib; {
        #    description = "A fork of picom featuring animations and improved rounded corners.";
        #    homepage = "https://github.com/jonaburg/picom";
        #    maintainers = with maintainers; oldAttrs.meta.maintainers ++ [ ];
        #  };
        #}))
    ];
}
