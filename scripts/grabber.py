from places import base, files

import os
import shutil


def grabber(from_root, dest_root, paths):
    for pth in paths:
        pth = pth.lstrip("/")
        if pth == "":
            continue

        from_path = os.path.join(from_root, pth)

        # get directories and filename from path
        parts = pth.split("/")
        folds, name = parts[:-1], parts[-1]

        # new folders if they don't exist
        folder = dest_root[:]
        for fold in folds:
            folder = os.path.join(folder, fold)
            if not os.path.isdir(folder):
                os.mkdir(folder)

        if os.path.isfile(from_path):
            shutil.copy(from_path, os.path.join(dest_root, pth))
        else:
            dest = os.path.join(dest_root, pth)
            if dest == pth:
                return "Attempted to delete source configs, aborting..."
            shutil.rmtree(dest, ignore_errors=True)
            shutil.copytree(from_path, dest)

    return "Configuration files copied to %s" % dest_root


if __name__ == "__main__":
    print(grabber("/", base, files))
    # print(grabber(base, "/", files))
