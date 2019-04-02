#!/bin/bash

# Watch Administrate folder.  Call sync script if any changes occur
fswatch -o -r ~/workspace/Administrate/ | xargs -n1 -I{} ~/.kevin/scripts/rsync_dev.sh &
# Watch neoteric folder.  Call sync script if any changes occur
fswatch -o -r ~/workspace/neoteric/ | xargs -n1 -I{} ~/.kevin/scripts/rsync_dev.sh &
