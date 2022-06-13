#!/bin/bash

# Create unison user and group
addgroup -g $UNISON_GID $UNISON_GROUP
adduser -u $UNISON_UID -G $UNISON_GROUP -s /bin/bash $UNISON_USER

# Create directory for filesync
if [ ! -d "$UNISON_DIR" ]; then
    echo "Creating $UNISON_DIR directory for sync..."
    mkdir -p $UNISON_DIR >> /dev/null 2>&1
fi

if [ ! -d "$UNISON_HOST_DIR" ]; then
    echo "Creating $UNISON_HOST_DIR directory for host sync..."
    mkdir -p $UNISON_HOST_DIR >> /dev/null 2>&1
fi

# /unison directory is created as a volume by onnimonni/unison
# make sure we can write to it
chown -R $UNISON_USER:$UNISON_GROUP /unison

# tell unison to use the /unison volume for its meta data,
# Because unison is writing to this often, it is better
# to be in a volume than on the root filesystem.
# However this is an anonymous volume, so it will be deleted if the container is
# removed.
export UNISON=/unison

# Change data owner
chown -R $UNISON_USER:$UNISON_GROUP $UNISON_DIR

# Start process on path which we want to sync
cd $UNISON_DIR

# Use a bash array () to store the cmd to be used twice below
# su-exec $UNISON_USER                -> Run as UNISON_USER, and forward signals
# unison $UNISON_HOST_DIR $UNISON_DIR -> sync two volumes
#  -prefer $UNISON_HOST_DIR           -> if there are conflicts choose the host
#  -auto                              -> handle conflicts automatically
#  -batch                             -> ask no questions
#  -log=false                         -> disable log file, docker tracks logs for us,
#     the log file will increase the size of the container root disk otherwise
#  -ignore 'Path .git'                -> ignore
# Run unison syncing UNISON_HOST_DIR and UNISON_DIR
UNISON_CMD=(su-exec $UNISON_USER unison $UNISON_HOST_DIR $UNISON_DIR \
  -prefer $UNISON_HOST_DIR
  -auto -batch -log=false \
  -ignore 'Path .git'\
  -ignore 'Path */tmp'\
  -ignore 'Path tmp')

# do an initial sync so we can let other containers know we are ready to go
# on the initial sync we mirror the host directory with -force
# this prevents a problem when the /unison container is removed, and the volume of
# $UNISON_DIR sticks around. In this situation, if the $UNISON_DIR volume changes
# or the $UNISON_HOST_DIR volume changes, unison will not know the history, and can do the
# wrong thing. For example if some files in the host directory are removed, in this state,
# then when the unison starts up again, (without the -force) it would copy the old files
# from $UNISON_DIR to $UNISON_HOST_DIR. In the majority of cases this is not what you
# want.
"${UNISON_CMD[@]}" -force $UNISON_HOST_DIR "$@"

echo "Initial sync complete, opening port 5001 to let the world know"
ncat -k -l 5001 --sh-exec 'echo "unsion is running"' &

# replace this script with unison so it receives te signals
# run the sync continously watching for changes
exec "${UNISON_CMD[@]}" -repeat watch "$@"