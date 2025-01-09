from places import base, files

import os
import shutil


def grabber(from_root, dest_root, paths):
    for pth in paths:
        pth = pth.lstrip("/")
        if pth == "":
            continue

        from_path = os.path.join(from_root, pth)
        dest_path = os.path.join(dest_root, pth)

        if os.path.exists(from_path):
            # new folders if they don't exist
            os.makedirs(os.path.dirname(dest_path), exist_ok=True)
            if os.path.isfile(from_path):
                shutil.copy(from_path, dest_path)
            elif os.path.isdir(from_path):
                if dest_path == pth:
                    return "Attempted to delete source configs, aborting..."
                shutil.rmtree(dest_path, ignore_errors=True)
                shutil.copytree(from_path, dest_path)

    return "Configuration files copied to %s" % dest_root


if __name__ == "__main__":
    print(grabber("/", base, files))
    # print(grabber(base, "/", files))
