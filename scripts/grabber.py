import os
import shutil


if __name__ == '__main__':
    # folder to configs to
    home = '/home/geoff/'
    basedir = home+'GitRepos/configs/confs/'

    # full path for each config to copy
    files = [
        home + '.Xresources',
        home + '.zshrc',
        home + '.oh-my-zsh/themes/my_custom.zsh-theme',
        # home + '.config/regolith/i3/config',
        home + '.i3/config',
        home + '.config/i3-scrot.conf',
        home + '.config/i3status/config',
        home + '.config/mimeapps.list',
        home + '.config/compton.conf',
        home + '.config/kitty/kitty.conf',
        home + '.config/nvim/init.vim',
        home + '.config/ranger/rc.conf',
        home + '.config/ranger/rifle.conf',
        home + '.config/rofi/config',
        home + '.config/flameshot/flameshot.conf',
        home + '.config/gtk-3.0/settings.ini',
        # home + '.config/polybar/config',
        home + '.doom.d/init.el',
        home + '.doom.d/config.el',
        home + '.doom.d/bindings.el',
        home + '.doom.d/pretty-fira.el',
        home + '.doom.d/packages.el',
        # '/etc/i3blocks.conf',
    ]

    for pth in files:
        # reset to basedir (../confs)
        copydir = basedir[:]

        # get directories and filename from path
        parts = pth.split('/')
        folds, name = parts[:-1], parts[-1]

        # new folders if they don't exist
        for fold in folds:
            if not os.path.isdir(os.path.join(copydir, fold)):
                os.mkdir(os.path.join(copydir, fold))
            copydir = os.path.join(copydir, fold)

        # copy into confs folder
        shutil.copy(pth, os.path.join(copydir, name))

    print('Configuration files copied to %s' % basedir)
