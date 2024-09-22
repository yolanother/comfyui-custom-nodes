
#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Get the directory where the script is located
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Iterate over all directories in the current directory
for dir in "$SCRIPT_DIR"/*; do
    # Skip if it's not a directory
    if [ -d "$dir" ]; then
        echo "Processing directory: $(basename "$dir")"

        # Navigate to the directory
        pushd "$dir" >/dev/null

        # Get the default branch (e.g., main or master)
        DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD | cut -d'/' -f3-)

        # Check if 'main' branch exists locally
        if git branch --list | grep -q "main"; then
            echo "Switching to existing 'main' branch"
            git checkout main
        else
            echo "Creating new 'main' branch from '$DEFAULT_BRANCH'"
            git checkout -b main "$DEFAULT_BRANCH"
        fi

        # Pull with rebase
        echo "Pulling with rebase..."
        git pull --rebase origin HEAD

        # Check if upstream is set
        CURRENT_UPSTREAM=$(git rev-parse --abbrev-ref --symbolic-full-name HEAD@{u} 2>/dev/null)
        if [ -z "$CURRENT_UPSTREAM" ]; then
            echo "Setting upstream for 'main' branch..."
            git branch --set-upstream-to=origin/main main
        else
            echo "Upstream already set for 'main' branch."
        fi

        # Return to the parent directory
        popd > /dev/null
    fi
done

echo "All repositories updated and upstreams configured successfully!"