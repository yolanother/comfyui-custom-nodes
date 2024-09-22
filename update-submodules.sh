#!/bin/bash
# Iterate over all subdirectories and add them as submodules
for dir in */; do
    repo_url=$(cd "$dir" && git config --get remote.origin.url)
    if [ -n "$repo_url" ]; then
        echo "Adding $dir as a submodule from $repo_url"
        git submodule add "$repo_url" "$dir"
    else
        echo "$dir is not a git repository."
    fi
done

# Commit the changes
git commit -am "Added all submodules"
