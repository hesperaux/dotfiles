# Dotfiles Repo (and subrepos)

To use dotfiles, first clone the repos you want:

`git clone --bare git@github.com:hesperaux/dotfiles.git ~/.dotfiles`

`git clone --bare git@github.com:hesperaux/wallfiles.git ~/.wallfiles`

`git clone --bare git@github.com:hesperaux/themefiles.git ~/.themefiles`

`git clone --bare git@github.com:hesperaux/fontfiles.git ~/.fontfiles`


Then, boostrap 'dotfiles' command with this alias:

`alias dotfiles='/usr/bin/git --git-dir=${HOME}/.dotfiles --work-tree=${HOME}'`

Then, run dotfiles bootstrap script:
NOTE: you may need to delete files in order for this command to work (.bashrc for example)

`~/.script/bootstrap_debian.sh dotfiles`

`dotfiles config --local status.showUntrackedFiles no`

Optionally, do the same for the other repos you cloned:

`fontfiles config --local status.showUntrackedFiles no`

`themefiles config --local status.showUntrackedFiles no`

`wallfiles config --local status.showUntrackedFiles no`

Now check them out:

`fontfiles checkout main`

`themefiles checkout main`

`wallfiles checkout main`

