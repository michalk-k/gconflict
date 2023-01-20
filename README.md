# GCONFLICT

## Preface

Gconflict is a set of bash scripts that helps identify potential conflicts between branches maintained in GIT repository. Giving programmers a tool that recognizes the same files they are working on in other branches, allows for mitigating those conflicts way before branches are merged together. 

All scripts are bash scripts with the use of basic tools available.

The major idea is to list all files touched in branches that are not yet merged to the master branch (such branches are later called open branches). If some file appears on the list more times, then it indicates the collision. The rest is more or less the output processing.

## Final solution first
For those who are looking for copy&use solution, copy the content of [.bashaliases](https://github.com/michalk-k/gconflict/blob/main/.bash_aliases) from repo to your bash_aliases file. To reload bash_aliases use `source ~/.bashrc` command or just open another console

Before using scripts, make sure you change your current dir to the GIT repo you want to check, and the local repo is up-to-date  (use git fetch --prune if needed).

All commands are determined by `GCONFL_BASE_EXCLUSSION` and `GCONFL_PATHS_MATCHED` variables. Both are regular expression patterns. The first defines branches that are always excluded from the match. The second matches the path(s) to the files being tested.

Additional customization of excluded branches is possible but not needed for common work. Read further chapters of this article for more details.

## Usage

### gconflict
With no arguments, the function looks for files changed in the currently selected branch and then looks for them in “open branches”. If found, those are listed as potentially conflicting files.

![gconflict](https://github.com/michalk-k/gconflict/blob/main/img/gconflict.png?raw=true)

### gconflict {arg}

The argument is expected to be a regular expression (for `egrep`). It's used to test filenames in mentioned "open branches". This mode is useful for resolving conflicts in the whole repo (read Checking whole repo chapter)

![gconflict arg](https://github.com/michalk-k/gconflict/blob/main/img/gconflict_arg.png?raw=true)

### gconflictglob

It lists all files found in open branches, potentially conflicting with each other. Those are sorted from more to less frequent conflicts. The number of conflicts is listed in the first column.

![gconflictglob](https://github.com/michalk-k/gconflict/blob/main/img/gconflictglob.png?raw=true)

To find exact branches containing specified file or files, use `gconflict` with argument

### gconflictloc

It is very similar to the one above. The difference is that it outputs files potentially conflicting with files touched in the local current GIT branch. Files of the current branch are taken from the local repo and then compared to the origin. It means, the local branch must not be pushed to the origin yet.

![gconflictloc](https://github.com/michalk-k/gconflict/blob/main/img/gconflictloc.png?raw=true)

The output of this function is used by `gconflict`
