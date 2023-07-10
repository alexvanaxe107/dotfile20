{ pkgs, ... }:

{
    home.packages = [ 
        pkgs.polybar 
        (pkgs.python3.withPackages(ps: [ps.pygobject3 ps.pydbus ps.click ps.i3ipc]))
        pkgs.bspwm
        pkgs.wmctrl
        pkgs.tmux
        pkgs.zsh
        pkgs.neovim
        pkgs.sxhkd
        pkgs.dunst
#    polybar = self.polybar;
        pkgs.nitrogen

        # media
        pkgs.yt-dlp
        pkgs.sxiv
        pkgs.imagemagick
        # picom = self.picom;
        pkgs.playerctl
        pkgs.cli-visualizer
        pkgs.pulseaudio
        pkgs.flameshot

        # utilities
        pkgs.gnome.pomodoro
        pkgs.eww
        pkgs.xclip
        pkgs.fzf
        pkgs.xsecurelock
        # programming
        pkgs.wezterm
        pkgs.unclutter

        pkgs.qutebrowser
        pkgs.fd

        # Nicities
        pkgs.fortune

        (pkgs.mpv.override {
          scripts = [ pkgs.mpvScripts.mpris ];
        })
        pkgs.spotify

        pkgs.rofi

        (import <avapkgs>).ava-chamaleon
    ];
}
