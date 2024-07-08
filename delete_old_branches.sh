#!/bin/bash

AGE_LIMIT=30 # Days

# Get a list of local branches and their last commit dates
branches=$(git branch --merged | grep -v "*" | xargs -I {} git show -s --format="%ct {}" | sort -n)

# Iterate over the branches and delete if older than the limit
for branch in $branches; do
    timestamp=$(echo $branch | cut -d " " -f 1)
    branch_name=$(echo $branch | cut -d " " -f 2-)

    if [ $(($(date +%s) - $timestamp)) -gt $((AGE_LIMIT * 24 * 60 * 60)) ]; then
        echo "Deleting branch $branch_name (older than $AGE_LIMIT days)"

        # Delete local branch
        git branch -d $branch_name

        # Delete remote branch (optional)
        # git push origin --delete $branch_name
    fi
done