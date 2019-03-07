if [ -z "$TMUX" ]
then
  exec tmux new-session
fi

case ${OSTYPE} in
  darwin*)
    EMACS="/Applications/Emacs.app/Contents/MacOS/Emacs"
    EMACSCLIENT="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
    alias emacs="$EMACS"
    alias emacsclient="$EMACSCLIENT"
    export EDITOR="$EMACSCLIENT -nw"
    ;;
  linux*)
    ;;
  msys*)
    if which start > /dev/null; then
      function mstart(){
        for arg in $@
        do
          start $arg
        done
      }
      alias start=mstart
    fi
    ;;
esac

[ -f ~/.zshrc.local ] && source ~/.zshrc.local

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [ ! -d $ZPLUG_HOME ]; then
  git clone https://github.com/zplug/zplug $ZPLUG_HOME
  source $ZPLUG_HOME/init.zsh && zplug update --self
fi

source $ZPLUG_HOME/init.zsh
zplug load

# zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
bindkey ' ' autosuggest-accept

# direnv setup
eval "$(direnv hook zsh)"

# path sort by string length
export PATH=$(echo $PATH \
         | tr : '\n' \
         | awk '{print length(), $0}' \
         | sort -nr \
         | cut -d ' ' -f 2 \
         | tr '\n' :)

if which zprof > /dev/null
then
  zprof
fi
