# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob nomatch notify
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/oskar/.zshrc'

# environment
export LC_TIME="sv_SE.UTF-8"
export LC_MONETARY="sv_SE.UTF-8"
export LC_MEASUREMENT="sv_SE.UTF-8"
export EDITOR="vim"
export BROWSER="chromium"
export PATH="/usr/lib/colorgcc/bin:$PATH"     # As per usual colorgcc installation, leave unchanged (don't add ccache)
export CCACHE_PATH="/usr/bin"                 # Tell ccache to only use compilers here
export PULSE_LATENCY_MSEC=60                  # No Skype sound distortion
# export PAGER="vimpager"

# color ls
LS_COLORS='rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:';
export LS_COLORS

# window title
case $TERM in
  termite|*xterm*|rxvt|rxvt-unicode|rxvt-256color|rxvt-unicode-256color|(dt|k|E)term)
    precmd () {
      #print -Pn "\e]0;[%n@%M][%~]%#\a"
      #print -Pn "\e]0;[%n@%M][%~]\a"
      print -Pn "\e]0;[%~] - URxvt\a"
    } 
    preexec () { print -Pn "\e]0;[%n@%M][%~]%# ($1)\a" }
    ;;
  screen|screen-256color)
    precmd () { 
      print -Pn "\e]83;title \"$1\"\a" 
      print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~]\a" 
    }
    preexec () { 
      print -Pn "\e]83;title \"$1\"\a" 
      print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~] ($1)\a" 
    }
    ;; 
esac

# history
bindkey  "^[[A"  history-beginning-search-backward
bindkey  "^[[B"  history-beginning-search-forward
setopt HIST_IGNORE_DUPS

# key bindings
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
function zle-line-init () {
    echoti smkx
}
function zle-line-finish () {
    echoti rmkx
}
zle -N zle-line-init
zle -N zle-line-finish 
# autoload
autoload -Uz compinit promptinit
compinit
promptinit
prompt walters

# completetion
zstyle ':completion:*' menu select
setopt completealiases

# man pages coloring
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

# aliases
alias vimxmonad='vim ~/.xmonad/xmonad.hs'
#alias netrestart='sudo systemctl restart netctl-auto@wlp1s0'
# alias netstart='sudo rfkill unblock wlan ; sudo rfkill unblock wifi ; sudo systemctl start netctl-auto@wlp1s0'
alias netstart='sudo rfkill unblock wlan ; sudo rfkill unblock wifi'
# alias netstop='sudo systemctl stop netctl-auto@wlp1s0 ; sudo rfkill block wlan ; sudo rfkill block wifi'
alias netstop='sudo rfkill block wlan ; sudo rfkill block wifi'
alias vncstart='vncserver -geometry 1920x1080 -alwaysshared -dpi 96 :1 ; x0vncserver -display :0 -passwordfile ~/.vnc/passwd'
alias vncstop='vncserver -kill :1'
alias pt='sudo powertop'
alias cal='cal -m'
alias rfkill='sudo rfkill'
alias ls='ls -h --color=auto'
alias grep='grep -n --color=auto'
#alias less=$PAGER
alias trayer='trayer --edge top --align left --SetDockType true --SetPartialStrut true --expand true --widthtype pixel --width 96 --transparent true --alpha 51 --tint 0x111111 --height 16'
alias qiv='qiv -itl'
alias am='alsamixer'
alias matlab='MATLAB_USE_USERWORK=1 ; synclient HorizTwoFingerScroll=0 ; ~/applications/MATLAB/R2015a/bin/matlab -nodesktop -nosplash ; synclient HorizTwoFingerScroll=1'
alias chromium='chromium --enable-overlay-scrollbar'
alias netflix='netflix-desktop'
alias sshcs='ssh tfy09otg@itchy.cs.umu.se'
alias fuck='sudo $(fc -ln -1)'
alias wgetpaste='wgetpaste -s dpaste'
alias extip='wget http://ipinfo.io/ip -qO -'
alias gosilent='sudo gosilent'
alias gobalanced='sudo gobalanced'
alias goperformance='sudo goperformance'
alias rmm='/usr/bin/rm'
alias rm='trash-put'
alias wgetpaste='wgetpaste -s gists'
alias xc='pwd | xsel --secondary'
alias xv='cd `xsel -o --secondary`'
alias rs='redshift -O 4800 -b 0.5'
alias msync='rsync --remove-source-files'
