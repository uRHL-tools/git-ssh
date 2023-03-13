#!/bin/bash

#TODO: check the required packets. If any of them is missing, warn the user and exit.

installation_dir=$(find $HOME -nowarn -name "git-ssh")
cd $installation_dir
bash git_ssh.sh
