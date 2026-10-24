# Commit all currently modified files with the current timestamp as the commit message.
#
# Optionally, call `gct push` to push the commit as soon as it's done.
# Does nothing if not in a git repository when called.
git_commit_timestamp() {
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git add -A
    git commit -m "$(date '+%Y-%m-%d %H:%M:%S')"
    if [[ $1 == "push" ]]; then
      git push
    fi
  else
    echo "Not inside a git repository."
  fi
}

# Alias the custom functions for simplicity
alias gct='git_commit_timestamp'
