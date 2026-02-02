setopt autocd
export PATH="$PATH:$HOME/.local/bin"

# load zgen
source "${HOME}/.zgen/zgen.zsh"
if ! zgen saved; then
  # specify plugins here
  zgen load zsh-users/zsh-history-substring-search
  zgen load zsh-users/zsh-syntax-highlighting

  zgen clone tinted-theming/base16-shell main
  zgen clone junegunn/fzf
  zgen clone ajeetdsouza/zoxide main

  # generate the init script from plugins above
  zgen save
fi

# zsh-history-substring-search configuration
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

# setup fzf
export PATH="$PATH:$HOME/.zgen/junegunn/fzf-master/bin"
if ! type "fzf" > /dev/null; then
  $HOME/.zgen/junegunn/fzf-master/install --bin
fi
source <(fzf --zsh)

# setup zoxide
if ! type "zoxide" > /dev/null; then
  $HOME/.zgen/ajeetdsouza/zoxide-main/install.sh
fi
eval "$(zoxide init zsh)"

# terminal colors
source "$ZGEN_DIR/tinted-theming/base16-shell-main/profile_helper.sh" 2>/dev/null
base16_tokyo-night-terminal-dark

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
alias g=git

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

lsport() {
  lsof -i:$1
}

if [[ -r "${HOME}/.zshrc-local" ]]; then
  source ${HOME}/.zshrc-local
fi

# Starship auto-install
if ! command -v starship &>/dev/null; then
  echo "Installing starship..."
  mkdir -p ~/.local/bin
  curl -sS https://starship.rs/install.sh | sh -s -- -b ~/.local/bin -y
fi
eval "$(starship init zsh)"



export HUSKY=0

