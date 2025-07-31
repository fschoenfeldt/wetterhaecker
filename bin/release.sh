#!/bin/bash
set -x

# release project on remote server

## set environment variables
export MIX_ENV="prod"
if [ -z "$SECRET_KEY_BASE" ]; then
  export SECRET_KEY_BASE=$(mix phx.gen.secret)
fi

## generate release
mix release --overwrite