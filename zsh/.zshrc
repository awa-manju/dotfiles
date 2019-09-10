autoload -Uz add-zsh-hook

if [ -z "$TMUX" ]
then
  if tmux list-session > /dev/null
  then
    exec tmux a
  else
    exec tmux new-session
  fi
fi

function my_refresh_tmux_status() {
  if [ ! -z $TMUX ]; then
    tmux refresh-client -S
  fi
}
add-zsh-hook periodic my_refresh_tmux_status

case ${OSTYPE} in
  darwin*)
    EMACS="/Applications/Emacs.app/Contents/MacOS/Emacs"
    EMACSCLIENT="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
    alias emacs="$EMACS"
    alias emacsclient="$EMACSCLIENT"
    alias e="$EMACSCLIENT -nw"
    alias ge="emacsclient-gui"
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

if [ ! -d $ZPLUG_HOME ]; then
  git clone https://github.com/zplug/zplug $ZPLUG_HOME
  source $ZPLUG_HOME/init.zsh && zplug update --self
fi
source $ZPLUG_HOME/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'
# zplug "aws/aws-cli", use:bin/aws_zsh_completer.sh, on:"zsh-users/zsh-completions", defer:2
# zplug "b4b4r07/zsh-vimode-visual", defer:3
# zplug "felixr/docker-zsh-completion"
zplug "hchbaw/opp.zsh", lazy:true
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux, lazy:true
zplug "paulirish/git-open", as:plugin
zplug "plugins/git", from:oh-my-zsh, if:"(( $+commands[git] ))", defer:2
# zplug "plugins/docker", from:oh-my-zsh, if:"(( $+commands[docker] ))", defer:2
# zplug "plugins/docker-compose", from:oh-my-zsh, if:"(( $+commands[docker-compose] ))", defer:2
zplug "mafredri/zsh-async"
# zplug "sindresorhus/pure"  # -> starthip
zplug "zsh-users/zsh-autosuggestions", defer:2
zplug "zsh-users/zsh-completions", lazy:true
zplug "zsh-users/zsh-history-substring-search", defer:2
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "yhiraki/docker-gcloud", as:command, use:"bin/*"

zplug "$ZDOTDIR", from:local, use:"rc/*.zsh"

zplug load

# starship setup
# which starship > /dev/null \
#   && eval "$(starship init zsh)"
PS1='\$ '

# direnv setup
which direnv > /dev/null \
  && eval "$(direnv hook zsh)"

# zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
bindkey '^ ' autosuggest-accept

if [ -d /usr/local/opt/fzf ]
then
  # Setup fzf
  if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
    export PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
  fi
  # Auto-completion
  [[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null
  # Key bindings
  source "/usr/local/opt/fzf/shell/key-bindings.zsh"
fi

# path sort by string length
export PATH=$(echo $PATH \
         | tr : '\n' \
         | awk '{print length(), $0}' \
         | sort -nr \
         | cut -d ' ' -f 2 \
         | tr '\n' :)

which zprof > /dev/null \
  && zprof

# zmodload zsh/zprof && zprof
