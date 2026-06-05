alias bat="bat --theme=gruvbox-dark"

alias f='nvim $(fzf -m --preview "bat --color=always  {}")'

alias dk='docker container rm $(docker container ls --format "{{.ID}} {{.Image}} {{.Names}}" | fzf --multi | awk "{print \$1}")'
# alias dexec='docker exec -it $(docker container ls --format "{{.ID}} {{.Image}} {{.Names}}" | fzf --multi | awk "{print \$1}") bash'
# alias pk='sudo -v; sudo lsof -i -P -n | sudo grep LISTEN | fzf --multi | awk "{print $2}" | xargs -r sudo pkill -9'
# alias pk='sudo -v; pids=$(sudo lsof -i -P -n | grep LISTEN | fzf --multi --header="Select processes to kill (PID in column 2)" | awk "{print \$2}" | sort -u | tr "\n" " "); [ -n "$pids" ] && echo "Killing PIDs: $pids" && sudo kill -9 $pids'
alias pk='sudo -v; sudo lsof -i -P -n | grep LISTEN | fzf --multi --header="Select processes to kill" | awk "{print \$2}" | sort -u | xargs -r sudo kill -9'
dexec() {
  shell=${1:-bash}  # Default to bash if no argument is provided
  docker exec -it $(docker container ls --format "{{.ID}} {{.Image}} {{.Names}}" | fzf --multi | awk '{print $1}') $shell
}

# temp for klox programming language
alias repl="gradle build && clear && java -jar build/libs/klox-1.0-SNAPSHOT.jar"
alias camunda="cd /home/geek/codes/personal/scripts/camunda && ./camunda-modeler > /dev/null  2>&1"

# Docker
alias dc="docker compose"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias dup="docker compose up -d"
alias down="docker compose down"

# Tmux
alias tn="tmux new-session -s"
alias tls="tmux ls"
alias aa="tmux a -t "
alias tk="tmux kill-session && echo 'all sessions killed !!'"

# Git
# alias gc="git commit -m"
# alias gca="git commit -a -m"
# alias gp="git push origin HEAD"
# alias gpu="git pull origin"
# alias gs="git status"
# alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
# alias gdiff="git diff"
# alias gco="git checkout"
# alias gb='git branch'
# alias gba='git branch -a'
# alias gadd='git add'
# alias ga='git add '
# alias gcoall='git checkout -- .'
# alias gr='git remote'
# alias gre='git reset'
# alias gsw='git switch'

# Aliases: git
alias ga='git add'
alias gap='ga --patch'
alias gb='git branch'
alias gba='gb --all'
alias gc='git commit -m'
alias gca='gc --amend --no-edit'
alias gce='gc --amend'
# alias gco='git checkout'
alias gcl='git clone --recursive'
alias gd='git diff --output-indicator-new=" " --output-indicator-old=" "'
alias gds='gd --staged'
alias gi='git init'
alias gl='git log --graph --all --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(auto)  %D%n%s%n"'
alias gm='git merge'
alias gn='git checkout -b'
alias gp='git push'
alias gr='git reset'
alias gs='git status --short'
alias gu='git pull'

gcof() {
    local branches branch
    branches=$(git --no-pager branch -vv) &&
    branch=$(echo "$branches" | fzf +m --height=50% --layout=reverse --border --ansi --preview-window=right:70% --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1)') &&
    git checkout $(echo "$branch" | sed 's/^..//' | cut -d' ' -f1)
}

gcos() {
    local selection
    
    # If not in git repo, use zi to navigate to one
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "🔍 Not in a git repository. Let's find one..."
        zi
        return
    fi
    
    selection=$(
        {
            # Recent branches (last 10)
            echo "📅 RECENT BRANCHES"
            git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short) | %(committerdate:relative) | %(subject)' | head -10 | sed 's/^/recent: /'
            
            echo ""
            echo "🌿 ALL LOCAL BRANCHES"
            # All local branches
            git branch --format='%(refname:short) | %(upstream:short) | %(subject)' | sed 's/^/local: /'
            
            echo ""
            echo "🌐 REMOTE BRANCHES"
            # Remote branches
            git branch -r --format='%(refname:short) | %(subject)' | grep -v '/HEAD' | sed 's/^/remote: /'
        } | fzf \
            --height=60% \
            --layout=reverse \
            --border=rounded \
            --ansi \
            --preview-window=right:60% \
            --preview 'branch=$(echo {} | cut -d" " -f2); git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" "$branch" 2>/dev/null | head -15' \
            --header='🚀 Select branch to checkout (Ctrl+D/U to scroll preview)' \
            --bind 'ctrl-d:preview-down,ctrl-u:preview-up' \
            --bind 'ctrl-r:reload(git fetch --all > /dev/null 2>&1; git for-each-ref --sort=-committerdate refs/heads/ --format="%(refname:short) | %(committerdate:relative) | %(subject)" | head -10 | sed "s/^/recent: /"; echo ""; echo "🌿 ALL LOCAL BRANCHES"; git branch --format="%(refname:short) | %(upstream:short) | %(subject)" | sed "s/^/local: /"; echo ""; echo "🌐 REMOTE BRANCHES"; git branch -r --format="%(refname:short) | %(subject)" | grep -v "/HEAD" | sed "s/^/remote: /")' \
            --prompt='Branch: ' \
    )
    
    if [[ -n "$selection" ]]; then
        local branch=$(echo "$selection" | awk '{print $2}' | cut -d'|' -f1 | xargs)
        # Handle remote branches
        if [[ "$selection" == remote:* ]]; then
            branch=$(echo "$branch" | sed 's#^[^/]*/##')
        fi
        git checkout "$branch"
    fi
}

# Ls
alias ll="eza -alh"
alias ls="eza --icons"
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltt="eza --tree --level=3 --long --icons --git"
alias tree="eza --tree"
alias c="clear"

alias ff="exec /usr/bin/zsh"
alias n="nvim"


alias clip="xclip -selection clipboard"

idea() {
    if [ -n "$1" ]; then
        PROJECT_DIR=$(realpath "$1")
        ~/.local/share/JetBrains/Toolbox/scripts/idea "$PROJECT_DIR" &>/dev/null &
    else
        ~/.local/share/JetBrains/Toolbox/scripts/idea &>/dev/null &
    fi
}
