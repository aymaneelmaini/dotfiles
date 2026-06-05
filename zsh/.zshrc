for config_file ($HOME/.zsh/config/*.zsh) source $config_file
for custom_file ($HOME/.zsh/custom/*.zsh) source $custom_file

source $ZSH/oh-my-zsh.sh
source <(fzf --zsh)

export PATH=$HOME/.local/bin:$PATH
export PATH=$PATH:/opt/zig

# temp
alias run="pnpm run"
alias gccc="gcc -Wall -Wextra"
alias vim="nvim"




# for mobile dev
# export ANDROID_HOME=$HOME/Android/Sdk
# export PATH=$PATH:$ANDROID_HOME/emulator
# export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH="$PATH:$HOME/dev/flutter/bin"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

alias gl='git log --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(auto)  %D%n%s%n"'


if [ -f '/home/geek/google-cloud-sdk/path.zsh.inc' ]; then . '/home/geek/google-cloud-sdk/path.zsh.inc'; fi
if [ -f '/home/geek/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/geek/google-cloud-sdk/completion.zsh.inc'; fi

export PATH="/home/geek/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/home/geek/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"
export ANDROID_HOME=/home/geek/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools
