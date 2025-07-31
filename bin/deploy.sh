#!/bin/bash

# synchronize project files
rsync --archive --compress --progress --partial --human-readable \
      --filter=":- ../.gitignore" --exclude=".git" $(pwd) \
      $UBERSPACE_USER@$UBERSPACE_SERVER:/home/$UBERSPACE_USER/
rsync --archive --compress --progress --partial --human-readable \
      $(pwd)/bin/wetterhaecker.ini \
      $UBERSPACE_USER@$UBERSPACE_SERVER:/home/$UBERSPACE_USER/etc/services.d/wetterhaecker.ini

# setup project on remote server. 
# NOTE: because ssh opens a non-interactive shell, 
#       we need to use 'bash -l -c' to ensure the login shell is used
#       and the environment variables are set correctly.
ssh -t $UBERSPACE_USER@$UBERSPACE_SERVER 'bash -l -c "cd wetterhaecker && ./bin/install.sh"'
ssh -t $UBERSPACE_USER@$UBERSPACE_SERVER 'bash -l -c "cd wetterhaecker && ./bin/release.sh"'
ssh -t $UBERSPACE_USER@$UBERSPACE_SERVER 'bash -l -c "cd wetterhaecker && ./bin/restart_service.sh"'
