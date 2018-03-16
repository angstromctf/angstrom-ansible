#!/bin/bash

if [ $# -ne 2 ] # Make sure problem name and directory are provided
then
  echo "Error: invalid arguments"
  echo "Usage: addproblem.sh [problem_name] [problem_dir]"
else
  # Check if the user already exists
  getent passwd problem-$1 > /dev/null 2&>1

  # If not, create the problem user and add it to the "problems" group
  if [ $? -eq 1 ]; then
    adduser problem-$1
    addgroup problem-$1 problem
  fi

  # Check if problem directory already exists
  if [ -n -e /problems/$1 ]; then
    mkdir /problems/$1
  fi

  # Set the owner of the problem's directory
  chown -R problem-$1:problem-$1 /problems/$1

  # Set the permissions and SETUID/SETGID
  chmod 6755 /problems/$1

  # Check if there is a flag file
  if [ -e /problems/$1/flag ]; then
    # Set reduced permissions for the flag
    chmod 440 /problems/$1/flag
  fi
fi
