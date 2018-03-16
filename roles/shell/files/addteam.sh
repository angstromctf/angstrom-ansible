#!/bin/bash

if [ $# -ne 2 ]
then
  echo "Error: invalid arguments"
  echo "Usage: addteam.sh [username] [password]"
else
  # Create the team
  adduser --home /teams/$1 --shell /bin/bash --ingroup teams --disabled-password --gecos "" $1
  chmod 700 /teams/$1
  
  # Set the team's password
  echo $1:$2 | chpasswd
fi
