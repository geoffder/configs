import platform
import os

home = os.path.expanduser("~/")
base = home + "git/configs/confs/" + platform.node() + "/"

# full path (or directory) for each config to copy
files = [
    # system themeing
    home + ".Xresources",
    home + ".gtkrc-2.0",
    home + ".config/gtk-3.0/settings.ini",
    home + ".config/qt5ct/qt5ct.conf",
    home + ".config/gtk-2.0",
    home + ".config/gtk-3.0",
    home + ".config/gtk-4.0",
    home + ".config/Kvantum",
    # TODO: I need to move these, I believe this is the wrong spot.
    home + ".themes/Adapta-DeepPurple-Nokto-Eta",
    home + ".themes/Papirus-Dark-Places-Violet",
    home + ".themes/Papirus-Adapta-Nokto-Violet",
    home + ".config/picom.conf",
    # shell / terminal
    home + ".zshenv",
    home + ".config/zsh/.zshrc",
    home + ".config/zsh/completion.zsh",
    home + ".config/zsh/setup.sh",
    home + ".config/zsh/aliases.sh",
    home + ".config/fsh/monokai.ini",
    home + ".config/fish",
    home + ".config/starship.toml",
    home + ".config/kitty",
    home + ".ocamlinit",
    home + ".utoprc",
    home + ".condarc",
    # editors
    home + ".doom.d",
    home + ".config/nvim/init.vim",
    # applications
    home + ".config/mimeapps.list",
    home + ".config/ranger/rc.conf",
    home + ".config/ranger/rifle.conf",
    home + ".config/joshuto",
    home + ".config/rofi",
    home + ".config/flameshot/flameshot.conf",
    home + ".config/firefox",
    home + ".config/dunst",
    home + ".config/vkBasalt",
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
    home + ".config/qtile/custom_popups.py",
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
    home + "qmk_firmware/keyboards/preonic/keymaps/geoffder_steno",
    home + "qmk_firmware/keyboards/keebio/iris/keymaps/geoffder",
    home + "qmk_firmware/keyboards/bastardkb/skeletyl",
    home + "qmk_firmware/keyboards/handwired/dometyl",
    # OpenSCAD
    home + ".config/OpenSCAD",
    # mpv
    home + ".config/mpv",
    home + ".config/jellyfin-mpv-shim",
]
