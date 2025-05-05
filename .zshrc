# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# load zgen
source "${HOME}/.zgen/zgen.zsh"
if ! zgen saved; then
  # specify plugins here
  zgen oh-my-zsh
  
  zgen oh-my-zsh plugins/history-substring-search

  zgen load romkatv/powerlevel10k powerlevel10k

  # generate the init script from plugins above
  zgen save
fi


# platform-specific setup
case "$(uname -s)" in
  Darwin)
    # macOS
    export PATH="/opt/homebrew/bin:$PATH"
    export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    if [[ -r "$HOME/.cargo/env" ]]; then
      . "$HOME/.cargo/env"
    fi
    ;;
  Linux)
    # Linux
    export PATH="$PATH:/usr/bin/code:$HOME/.local/bin/code"
    export PATH="$HOME/.local/bin:$PATH"
    ;;
esac

# autoinstall nvm
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_TARGET_VER}/install.sh" | bash
fi
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# vim bindings
bindkey -v

# ffmpeg
vid2gif() {
  ffmpeg -i $1 \
    -vf "fps=15,scale=trunc(iw*3/4):-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
    -loop 0 $2
}

# git config
git config --global push.autoSetupRemote true
git config --global merge.conflictstyle diff3

# git aliases; not much, but they're mine
git_default_branch() {
  git config --get init.defaultBranch
}

git_current_remote() {
  git rev-parse --abbrev-ref --symbolic-full-name @{u} | sed 's/\/.*//'
}

gpro() {
  git pull --rebase "$(git_current_remote)" $1
}

gfo() {
  git fetch "$(git_current_remote)" "$1:$1"
}

git_delete() {
  git rebase --rebase-merges --onto $1^ $1
}

git_checkout_chunks() {
  git checkout "$1" -- ${@:2}
  git reset ${@:2}
  git add -p ${@:2}
  git restore .
}

killport() {
  kill -9 $(lsof -t -i:$1)
}

if [[ -r "${HOME}/.zshrc-local" ]]; then
  source ${HOME}/.zshrc-local
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

