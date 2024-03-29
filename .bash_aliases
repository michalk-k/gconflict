export GCONFL_BASE_EXCLUSSION="^origin/(master|uat|release)|->"
export GCONFL_PATHS_MATCHED="^db/(structure|fixtures|tests)/"
alias gconflictglob='for k in $(git branch -r --no-merged master | sed s/^..// | grep -E -v "$GCONFL_BASE_EXCLUSSION" | grep -E -v "${BRANCHES_EXCLUDED:-"^$"}" | grep -E "$BRANCHES_INCLUDED"  ); do echo -e $k\\n "$(git --no-pager log --name-only origin/master..$k | grep -E "$GCONFL_PATHS_MATCHED" | sort | uniq)" ;done | grep -E -v "^[ ]*$" | sort | uniq -c  | grep -v "^ *1 "'
alias gconflictloc='for k in $(git branch -r --no-merged master | sed s/^..// | grep -E -v "$GCONFL_BASE_EXCLUSSION" | grep -E -v "${BRANCHES_EXCLUDED:-"^$"}" | grep -E "$BRANCHES_INCLUDED"  ); do echo -e "$(git --no-pager log --name-only origin/master..$k | grep -E "$GCONFL_PATHS_MATCHED" | grep -E -v "^$" | sort | uniq)";done | grep -E ^\($(git --no-pager log --name-only origin/master.. | grep -E "$GCONFL_PATHS_MATCHED" | tr "\n" "|" | sed "s/.$//")\)$ | sort | uniq -c  | grep -v "^ *1 "'

gconflict()
{
    echo "base branches    : $GCONFL_BASE_EXCLUSSION"
    echo "matched paths    : $GCONFL_PATHS_MATCHED"
    echo "excluded branches: $BRANCHES_EXCLUDED"
    echo "matched branches : $BRANCHES_INCLUDED"
    echo ""

    if [ -z $1 ]
    then
        REF=$(git for-each-ref --format='%(upstream:short)' "$(git symbolic-ref -q HEAD)")
        echo "Seeking open branches for potencially conflicting files with current branch: $REF"

        RGX=$(gconflictloc | sed 's/^ *[0-9]\{1,\} //' | tr "\n" "|"  | sed "s/.$//")

        if [ -z $RGX ]
        then
            echo "No conflicting files found"
            return 0
        fi

        RGX="^($RGX)$"
    else
        echo "Seeking open branches for files matching regular expression: $1"

        REF=" "
        RGX=$1
    fi


    for k
    in $(git branch -r --no-merged master | sed s/^..// | grep -E -v "$GCONFL_BASE_EXCLUSSION|$REF" | grep -E -v "${BRANCHES_EXCLUDED:-"^$"}" | grep -E "$BRANCHES_INCLUDED"  );
    do
        X=$(git --no-pager log --name-only origin/master..$k | grep -E "$GCONFL_PATHS_MATCHED" | sort | uniq | grep -E "$RGX" ) && echo -e \\n$(tput bold)$k$(tput sgr0)\\n"$X";
    done
}
