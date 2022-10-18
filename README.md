# Git SSH client <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a>

The easiest way to work with GitHub repositories using SSH keys

## Pre-requisites

### Dependencies
- Yaml reader (check my other repo)
- ssh (ssh-keygen, ssh-agent, ssh-add)
- git

### Create your own SSH keys

You will need to create a pair of SSH keys. These keys are used to authenticate you, thus you need to specify the email (identity) that you want to be authenticated. GitHub recommendates to use the algorithm ED25519.

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

### Configuration

There are two parameters that can be configured in the file `conf.yml`

- `gitRootDir` (optional): Specifies the path the root directory used to keep the cloned repositories. I like to keep all of them in `$HOME/git`, but you may use any folder you want.
  
- `kNames` (mandatory): A list of the names of all the keys that you may use for GitHub ssh-authenticated sessions. Those keys should be previously created and included in the default SSH directory (/home/you/.ssh)
## Usage

First of all, clone the repo

```bash
git clone https://github.com/uRHL-tools/git-ssh-client.git

```

Execute the script `run.sh` to get it running.

```bash
./git-ssh-client/run.sh
```

For a more confortable use you may want to create a shortcut (symbolic link).

```bash
sudo ln -s ~/path/to/git-ssh-client/run.sh /usr/local/bin/git-ssh
```

Now, to execute it you only need to type

```bash
git-ssh
```
## Future work

- [ ] Auto-check dependencies and install them
- [ ] Add a log
- [ ] Enable installation via apt

## License

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.
