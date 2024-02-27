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
  zgen load romkatv/powerlevel10k powerlevel10k

  # generate the init script from plugins above
  zgen save
fi

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
  git pull --rebase $(git_current_remote) $1
}

gfo() {
  git fetch $(git_current_remote) $1:$1
}

gco() {
  git checkout $1
}

gcot() {
  git checkout --track $1
}

source ${HOME}/.zshrc-local || true

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
