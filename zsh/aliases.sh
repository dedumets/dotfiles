# Custom aliases
alias pip='python3 -m pip'
alias todos='rg -i "TODO|FIXME|HACK|XXX" --color=always'
alias fkill='kill $(ps aux | fzf | awk '"'"'{print $2}'"'"')'

# Native commands replaced with third-party tooling
alias ls='eza --icons always'
alias ll='eza -l --git --icons always'
alias la='eza -la --git --icons always'
alias lt='eza --tree --level=2 --icons always'
compdef _eza ls ll la lt
alias cat='bat'
alias diff='delta'
