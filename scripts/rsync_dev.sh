#!/bin/bash

# sync Adminstrate directory
# The --include options are present so that files that are actually in the
# repo, but excluded within the .gitignore file, are also synced
# The --filter option is included to respect the contents of .gitignore when syncing
rsync -azvh \
    -e "ssh -p 620" \
    --progress \
    --delete \
    --include=".cvsignore" \
    --include=".git/" \
    --exclude="*.swp" \
    --filter=":- ~/workspace/Administrate/.gitignore" \
    ~/workspace/Administrate/ \
    kjm@dev.administratehq.com:~/core \
    2>&1 >~/.kevin/rsync_Administrate.log

# sync neoteric directory
# The --filter option is included to respect the contents of .gitignore when syncing
rsync -azvh \
    -e "ssh -p 620" \
    --progress \
    --delete \
    --include=".git/" \
    --exclude=".vscode" \
    --exclude=".env" \
    --exclude="*.swp" \
    --exclude="config.py*" \
    --exclude="alchemy_config.py*" \
    --exclude="xtext.txt" \
    --exclude=".*" \
    --exclude="requirements.txt" \
    --filter=":- ~/workspace/neoteric/.gitignore" \
    ~/workspace/neoteric/ \
    kjm@dev.administratehq.com:~/neoteric \
    2>&1 >~/.kevin/rsync_neoteric.log

