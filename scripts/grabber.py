import os
import shutil


def copier(base_dir, paths):
    for pth in paths:
        if pth == "":
            continue
        
        # reset to basedir (../confs)
        dest = base_dir[:]

        # get directories and filename from path
        parts = pth.split('/')
        folds, name = parts[:-1], parts[-1]

        # new folders if they don't exist
        for fold in folds:
            if not os.path.isdir(os.path.join(dest, fold)):
                os.mkdir(os.path.join(dest, fold))
            dest = os.path.join(dest, fold)

        if os.path.isfile(pth):
            shutil.copy(pth, os.path.join(dest, name))
        else:
            dest = os.path.join(base_dir[:], pth[1:] if pth[0] == "/" else pth)
            if dest == pth:
                return "Attempted to delete source configs, aborting..."
            shutil.rmtree(dest, ignore_errors=True)
            shutil.copytree(pth, dest)

    return "Configuration files copied to %s" % base_dir


if __name__ == '__main__':
    home = "/home/geoff/"
    base = home + "GitRepos/configs/confs/"

    # full path for each config to copy
    files = [
        home + ".Xresources",
        home + ".zshrc",
        home + ".gtkrc-2.0",
        home + ".oh-my-zsh/themes/my_custom.zsh-theme",
        home + ".i3/config",
        home + ".doom.d",
        home + ".themes/Monokai-ish",
        home + ".config/i3-scrot.conf",
        home + ".config/i3status/config",
        home + ".config/openbox",
        home + ".config/polybar",
        home + ".config/mimeapps.list",
        home + ".config/picom.conf",
        home + ".config/kitty/kitty.conf",
        home + ".config/nvim/init.vim",
        home + ".config/ranger/rc.conf",
        home + ".config/ranger/rifle.conf",
        home + ".config/rofi",
        home + ".config/flameshot/flameshot.conf",
        home + ".config/gtk-3.0/settings.ini",
        home + ".config/firefox",
    ]
    
    print(copier(base, files))
