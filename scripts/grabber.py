import os
import shutil


if __name__ == '__main__':
    # folder to configs to
    home = '/home/geoff/'
    copydir = home+'GitRepos/configs/confs/'

    # [path, fname] for each config to copy
    files = [
        home + '.Xresources',
        home + '.zshrc',
        home + '.i3/nvim_workspace.json',
        home + '.config/kitty/kitty.conf',
        home + '.config/i3-regolith/config',
        home + '.config/nvim/init.vim',
        home + '.config/ranger/rc.conf',
        home + '.config/ranger/rifle.conf',
        '/etc/i3blocks.conf'
    ]

    for pth in files:
        # get last directory and filename from path
        fold, name = pth.split('/')[-2:]

        # new folder if doesn't exist
        if not os.path.isdir(os.path.join(copydir, fold)):
            os.mkdir(os.path.join(copydir, fold))

        # copy into confs folder
        shutil.copy(pth, os.path.join(copydir, fold, name))

