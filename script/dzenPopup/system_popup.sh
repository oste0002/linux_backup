#A simple popup showing system information

HOST=$(uname -n)
KERNEL=$(uname -r)
UPTIME=$( uptime | sed 's/.* up //' | sed 's/[0-9]* us.*//' | sed 's/ day, /d /'\
         | sed 's/ days, /d /' | sed 's/:/h /' | sed 's/ min//'\
           |  sed 's/,/m/' | sed 's/  / /')
PACKAGES=$(pacman -Q | wc -l)
UPDATED=$(awk '/upgraded/ {line=$0;} END { $0=line; gsub(/[\[\]]/,"",$0); \
         printf "%s %s",$1,$2;}' /var/log/pacman.log)

(
echo "System Information" # Fist line goes to title
# The following lines go to slave window
echo "Host: $HOST "
echo "Kernel: $KERNEL"
echo "Uptime: $UPTIME "
echo "Pacman: $PACKAGES packages"
echo "Updated: $UPDATED"
) | dzen2 -p '6' -x "1415" -y "16" -w "270" -l "5" -sa 'c' -ta 'c' -bg '#001122' -h '16' -fn Inconsolata-12 -fg '#EEEEEE' -e 'onstart=uncollapse;button1=exit;button3=exit'

# "onstart=uncollapse" ensures that slave window is visible from start.
