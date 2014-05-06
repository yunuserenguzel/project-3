#!/bin/bash

rspec

if [ $? -eq 0 ]
  then 
    echo 'Tests ended successfully, removing git repository'
    
    git add .
    git commit -m "Created repo for heroku"
    git push heroku -f staging master

    echo 'Push to Heroku complete'
    echo "You can delete the git repository by typing 'rm -rf .git'" 
else
  echo 'Please fix the tests before continuing'
fi
