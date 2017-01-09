Media sources
=============

All sources for the mod pack, included here for GPL compliance and ease of building




Special thanks for artwork:

* Melanosuchus
* Snow_56767
* KingPimpCommander



Build Script
============

`./build.sh` can be used to generate a pk3 with all the data files generated from the sources.

`./build.sh` (without parameters) will create default packages with all the files of each subdirectory (the file names depend on the result of `git describe`).
All the image files will be fonverted in JPEGs with a separate alpha channel.

To optimize speed, it will only re-generate data files when the corrisponding sources have been modified.
This means that a deleted file can result in the pk3; to remove old generated files run `./build.sh clean`.

You can generate just the pk3 of a given subdirectory (eg: `./build.sh minigames`) and use a specific pk3 name for the result (`./build.sh minigames -o zzz-minigames.pk3`).

The scripts only considers the files tracked by `git`, so you'll need to add files for them to appear (they don't need to be committed or to have all changes staged).

Other than the most basic utilities provided by a POSIX shell (it might work with similar shells but only `bash` is supported) it uses ImageMagick, `zip` and `bc`.
