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
REMOTE_API="https://api.github.com/users/${GITH_USER}/repos?sort=updated&per_page=5&page=1"

function manifest_check(){
  # git log --pretty=format:%h -2
  COMMIT_HASH=`git log --pretty=format:%h -2`
  BEFORE=`echo ${COMMIT_HASH} | cut -d " " -f 1` >> /dev/null
  AFTER=`echo ${COMMIT_HASH} |  cut -d " " -f 2` >> /dev/null

  git diff $BEFORE $AFTER --exit-code --name-only --relative=Porfile_auto_generator 
  #git diff HEAD --relative=bucket --exit-code --name-only
  echo $?
}


function main(){
  MAN_CHECK=$(manifest_check)
  if [ $MAN_CHECK == 0 ];then
     echo "No Update"
     return 0;
  fi
  echo "Setupping ..."
  (cd git_getter;yarn install;node main.js)

  TMP_FILE=$(tempfile)
  echo "Getting Your Repo..."
  REPO_DATA=$(cat "./repos.json")
  MAX_COUNTER=$(echo ${REPO_DATA} | jq '.[].name' -r | wc -l);

  cat ./Header.md >> $TMP_FILE
  cat ./list/repo_list_header.md >> $TMP_FILE
  for (( count=0; count<${MAX_COUNTER}; count++));do
     Repo_name=$(echo $REPO_DATA | jq .[$count].name -r)
     Repo_url=$(echo $REPO_DATA | jq .[$count].clone_url -r)
     update_time=`date -d $(echo $REPO_DATA | jq .[$count].updated_at -r) '+%F %R'`
    eval "echo \"$(eval cat ${README_TEMPLATE}/list/body.md)\"" >> ${TMP_FILE}
  done
  cat ./Footer.md >> $TMP_FILE

  echo "Update README.md"
  mv ${TMP_FILE} ${README_DEPLOY}/README.md
  git add ${README_DEPLOY}/README.md;
  git commit -m "${COMMIT_MESSAGE}"
  git push
  git reset
}

main
