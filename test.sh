#!/bin/bash
#repo=$(echo "git@github.com:uRHL/artsem.git" | cut -d'/' -f 2 | cut -d'.' -f 1)

arr=("git@github.com:uRHL/artsem.git" "git@github.com:uRHL/all-writes-up.git" "git@github.com:uRHL/bomberman-game.git" "git@github.com:uRHL/kprj.git" "git@github.com:uRHL/assembly-programming.git" "git@github.com:uRHL/dusty-miner.git" "git@github.com:uRHL/urhl.github.io.git" "git@github.com:uRHL/mds-job-genius.git" "git@github.com:uRHL/mm-IMDb-database.git" "git@github.com:uRHL/Distributed-Systems-OWN.git" "git@github.com:uRHL/OS-Design.git")

for i in ${arr[@]}; do
    # Remove '.git' suffix then split the repo name from the url
    echo "${i%.git}" | cut -d'/' -f 2
done
