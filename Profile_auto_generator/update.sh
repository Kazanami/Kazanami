#!/usr/bin/env bash

# Thank you Download This Script.
# This program can running on Github Actions.
# I checked successfull running on Github Actions.
#
# Require Env Parameter
#
# ${GITH_USER} -> Push Commit Username
# ${GITH_EMAIL} -> Push Commit User Email

# Debug Mode Switch
if [ $DEBUG_MODE = 0 ];then
  set -u
else
  set -uex
fi

# Upload Git Settings
git config --global user.name ${GITH_USER}
git config --global user.email ${GITH_EMAIL}
COMMIT_MESSAGE="Profile: Update!"
README_TEMPLATE="${PWD}"
README_DEPLOY=$(dirname ${PWD})
