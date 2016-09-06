#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias vimxmonad='vim ~/.xmonad/xmonad.hs' 
alias netrestart='sudo systemctl restart netctl-auto@wlp1s0'
alias netstart='sudo rfkill unblock wlan ; sudo rfkill unblock wifi ; sudo systemctl start netctl-auto@wlp1s0'
alias netstop='sudo systemctl stop netctl-auto@wlp1s0'
alias dhcpcd='sudo dhcpcd'
alias vncstart='vncserver -geometry 1920x1080 -alwaysshared -dpi 96 :1 ; x0vncserver -display :0 -passwordfile ~/.vnc/passwd'
alias vncstop='vncserver -kill :1'
alias pt='sudo powertop'
alias cal='cal -m'
alias rfkill='sudo rfkill'
alias ls='ls --color=auto'
alias trayer='trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 6 --transparent true --alpha 0 --tint 0x000000 --height 16'
alias qiv='qiv -i'
alias am='alsamixer'
alias netflix='netflix-desktop'
PS1='[\u@\h \W]\$ '
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
export PATH="/usr/lib/colorgcc/bin/:$PATH"    # As per usual colorgcc installation, leave unchanged (don't add ccache)
export CCACHE_PATH="/usr/bin"                 # Tell ccache to only use compilers here
