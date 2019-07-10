import os
import shutil


if __name__ == '__main__':
    # folder to configs to
    home = '/home/geoff/'
    copydir = home+'GitRepos/configs/confs/'

    # [path, fname] for each config to copy
    files = [
        [home, '.Xresources'],
        [home+'.config/i3-regolith/', 'config'],
        [home+'.config/nvim/', 'init.vim'],
        [home+'.config/ranger/', 'rc.conf'],
        [home+'.config/ranger/', 'rifle.conf'],
        ['/etc/', 'i3blocks.conf']
    ]

    for pth, name in files:
        # get last directory (last ele is '', all end in '/')
        fold = pth.split('/')[-2]

        # new folder if doesn't exist 
        if not os.path.isdir(os.path.join(copydir, fold)):
            os.mkdir(os.path.join(copydir, fold))

        # copy into confs folder
        shutil.copy(
            os.path.join(pth, name),
            os.path.join(copydir, fold, name)
        )

