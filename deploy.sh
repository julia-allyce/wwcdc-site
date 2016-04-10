#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

git config user.name "Travis CI"
git config user.email "<you>@<your-email>"

# Build the project.
hugo

toreturn=$?

if [ $toreturn -eq 0 ] 
then
  # Push source and build repos.
  git subtree split --prefix=public -b gh-pages
  # Add changes to git.
  git add -A

  # Commit changes.
  msg="rebuilding site `date`"
  if [ $# -eq 1 ]
    then msg="$1"
  fi
  git commit -m "$msg"
  git push -f "https://$GH_TOKEN@$GH_REF" gh-pages:gh-pages > /dev/null 2>&1
  git branch -D gh-pages
fi
exit $toreturn
