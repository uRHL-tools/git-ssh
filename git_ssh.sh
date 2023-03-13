#!/bin/bash
## Generating OpenSSH key pair (github)
# Github Docs: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

# 1. Generate the key: `ssh-keygen -t ed25519 -C "your_email@example.com"`
# 2. Adding your SSH key to the ssh-agent
#  1. Start ssh-agent in the background: `eval "$(ssh-agent -s)"`
#  2. Add the key to the agent: `ssh-add ~/.ssh/id_ed25519`
#  3. Add the key to GitHub: `cat ~/.ssh/id_ed25519.pub`

# TODO: add log (sessions created and attemps (dir and keys), git commands (clone, pull, commit, push...))

# ----------------------------------------------------
# GLOBALS
# ----------------------------------------------------

CONF="./conf.yml"
#CONF=$(find $HOME -name "github_conf.yml")
REPO_SHORTCUTS=('Git status' 'Git pull' 'Commit all (git add. && git commit -a)' 'Git push' 'End session')
NO_REPO_SHORTCUTS=('Git clone' 'End session')
git_root_dir=""
session_key=""
separator="------------------------------------------"

# ----------------------------------------------------
# FUNCTIONS
# ----------------------------------------------------

function pause() {
    read -p "Press enter to continue"
}

function selectGitRootDir() {
    root_dir=""
    while true; do
        read -p "Please specify the path to the git root folder: " rdir
        if [ -z "${rdir}" ]; then
            echo -e "[ERROR] Path cannot be empty"
        elif [ -d $rdir ]; then
            #return $rdir
#            echo $rdir            
            git_root_dir="$rdir"
            break
        else
            echo -e "[ERROR] Directory '$rdir' does not exists"
        fi
    done
}

# ----------------------------------------------------
# MAIN
# ----------------------------------------------------


# 1. Select Gitroot folder to be used in this session
git_root_dir=$(yaml $CONF gitRootDir 2> /dev/null)
if [ -z $git_root_dir ]; then
    echo -e "[INFO] Git root directory not configured. Trying to find it..."
    git_root_dir=$(find $HOME -maxdepth 1 -name "git")
fi

if [ -z $git_root_dir ]; then
    echo -e "[INFO] Git root directory not found in default location ($HOME/git)"
    selectGitRootDir
else
    echo -e "[INFO] Default Git root directory found"
fi

read -p "Using root Git dir: $git_root_dir. Is this okay? [Y/n] " choose
while [[ $choose == "n" || $choose == "N" ]]; do
    selectGitRootDir
    read -p "Using root Git dir: $git_root_dir. Is this okay? [Y/n] " choose
done

# 2. Select the key
all_keys=($(yaml $CONF kNames))
if [ ${#all_keys[@]} -eq 0 ]; then
    echo -e "[ERROR] No keys defined. Update ~/github_conf.yml"
    exit 1
elif [ ${#all_keys[@]} -eq 1 ]; then
    session_key=${all_keys[0]}
else
    while true; do
        echo -e "[INFO] Multiples keys defined\n>"    
        for i in ${!all_keys[@]};
        do
            echo "  $(( $i + 1)). ${all_keys[$i]}"
        done
        echo ">"
        read -p "Please select one to continue: " kindex
        kindex=$(( $kindex - 1 ))
        if [[ $kindex -lt 0 || $kindex -gt $(( ${#all_keys[@]} - 1 )) ]]; then
            echo -e "[ERROR] Index out of bounds"
        else
            session_key=${all_keys[$kindex]}
            break
        fi
    done
fi

echo "[INFO] Using key '$session_key'"

# 3. Run ssh client agent
eval "$(ssh-agent -s)"

if ! [ $? -eq 0 ]; then
    echo -e "[ERROR] 'ssh-agent' could not be initialized"
    exit 1
fi

# 4. Add the session key
ssh-add ~/.ssh/$session_key

if ! [ $? -eq 0 ]; then
    echo -e "[ERROR] Session key could not be added to ssh-agent"
    exit 1
fi

# 5. Start coding
echo -e "[INFO] Starting session..."
echo -e "$separator\nSESSION $(date +%F-%H-%M)\n  Git root dir: $git_root_dir\n           Key: $session_key\n$separator"
cd $git_root_dir

while true; do
    echo $separator
    if [ -d "$(pwd)/.git" ]; then
        echo -e "[INFO] Current repo: $(pwd)"
        echo -e "Shortcuts\n>"
        for i in ${!REPO_SHORTCUTS[@]};
        do
            echo "  $(( $i + 1)). ${REPO_SHORTCUTS[$i]}"
        done
        echo -e ">\nSelect a shortcut or type a command"
        read -p "~$ " command

        case $command in
        1)
            git status
        ;;
        2)
            git pull
        ;;
        3)
            read -p "Commit message: " msg
            git add .
            git commit -am "$msg"
        ;;
        4)
            git push
        ;;
        5)
            # Exit
            echo -e "[INFO] Session ended. Exiting..."
            exit 0
        ;;
        *)
            # Other command
            eval "$command"
        ;;
        esac
    else
        echo -e "[WARN] Current directory is NOT a git repository\n[INFO] Current dir: $(pwd)"
        echo -e "Shortcuts\n>"
        for i in ${!NO_REPO_SHORTCUTS[@]};
        do
            echo "  $(( $i + 1)). ${NO_REPO_SHORTCUTS[$i]}"
        done
        echo -e ">\nSelect a shortcut or type a command"
        read -p "~$ " command
        case $command in
            1)
                read -p "Repo ssh-url: " repo
                git clone $repo
                if [ $? -eq 0 ]; then
                    repo_name=$(echo "${repo%.git}" | cut -d'/' -f 2)
                    cd $repo_name
                else
                    continue
                fi
            ;;
            2)
                # Exit
                echo -e "[INFO] Session ended. Exiting..."
                exit 0
            ;;
            *)
                # Any other command
                eval $command
            ;;
        esac  
    fi
    sleep 1s
    
done

