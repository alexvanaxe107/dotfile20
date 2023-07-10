{ config, pkgs, ... }:

{

  imports = [ ./ava.nix ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "alexvanaxe";
  home.homeDirectory = "/home/alexvanaxe";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
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
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/alexvanaxe/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
