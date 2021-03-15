import os

home = os.path.expanduser("~/")
base = home + "GitRepos/configs/confs/"

# full path (or directory) for each config to copy
files = [
    # system themeing
    home + ".Xresources",
    home + ".gtkrc-2.0",
    home + ".config/gtk-3.0/settings.ini",
    home + ".config/qt5ct/qt5ct.conf",
    # TODO: I need to move these, I believe this is the wrong spot.
    home + ".themes/Adapta-DeepPurple-Nokto-Eta",
    home + ".themes/Papirus-Dark-Places-Violet",
    home + ".themes/Papirus-Adapta-Nokto-Violet",
    home + ".config/picom.conf",
    # shell / terminal
    # home + ".zshrc",
    # home + ".oh-my-zsh/custom/themes",
    home + ".fsh/monokai.ini",
    home + ".config/fish",
    home + ".config/starship.toml",
    home + ".config/kitty",
    home + "miniconda3/etc/conda/activate.d",
    home + ".ocamlinit",
    home + ".utoprc",
    # editors
    home + ".doom.d",
    home + ".config/nvim/init.vim",
    # applications
    home + ".config/mimeapps.list",
    home + ".config/ranger/rc.conf",
    home + ".config/ranger/rifle.conf",
    home + ".config/rofi",
    home + ".config/flameshot/flameshot.conf",
    home + ".config/firefox",
    # XMonad
    home + ".xmonad/xmonad.hs",
    home + ".xmonad/xmonad_notes.md",
    home + ".xmonad/xpm",
    home + ".xmonad/lib/ClickableWsHook.hs",
    home + ".xmonad/lib/ClickableWorkspaces.hs",
    home + ".config/xmobar",
    # Qtile
    home + ".config/qtile/icons",
    home + ".config/qtile/config.py",
    home + ".config/qtile/autostart.sh",
    # Openbox
    home + ".themes/Monokai-ish",
    home + ".config/openbox",
    home + ".config/polybar",
    # i3
    home + ".i3/config",
    home + ".config/i3-scrot.conf",
    home + ".config/i3status/config",
    # QMK
    home + "qmk_firmware/keyboards/preonic/keymaps/geoffder",
    home + "qmk_firmware/keyboards/keebio/iris/keymaps/geoffder",
]
