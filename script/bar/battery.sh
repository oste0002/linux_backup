CUTE_BATTERY_INDICATOR="false"

HEART_FULL=♥
HEART_EMPTY=♡
[ -z "$NUM_HEARTS" ] &&
    NUM_HEARTS=6

cutinate()
{
    perc=$1
    inc=$(( 100 / $(($NUM_HEARTS + 1))))
    forinc=$inc

    for i in `seq $NUM_HEARTS`; do
        if [ $perc -ge $inc ]; then
            echo $HEART_FULL
        else
            echo $HEART_EMPTY
        fi
	inc=$(( $inc + $forinc ))
    done
}

linux_get_bat ()
{
    bf=$(cat $BAT_FULL)
    bn=$(cat $BAT_NOW)
    echo $(( 100 * $bn / $bf ))
}

battery_status()
{
        BATPATH=/sys/class/power_supply/BAT0
        STATUS=$BATPATH/status
        BAT_FULL=$BATPATH/charge_full
		if [ ! -r $BAT_FULL ]; then
			BAT_FULL=$BATPATH/energy_full
		fi
        BAT_NOW=$BATPATH/charge_now
		if [ ! -r $BAT_NOW ]; then
			BAT_NOW=$BATPATH/energy_now
		fi

        if [ "$1" = `cat $STATUS` -o "$1" = "" ]; then
            linux_get_bat
        fi
}

BATTERY_STATUS=`battery_status $1`
[ -z "$BATTERY_STATUS" ] && exit

if [ "$CUTE_BATTERY_INDICATOR" == "true" ]; then
    echo `cutinate $BATTERY_STATUS`
else
    #echo "${HEART_FULL} ${BATTERY_STATUS}%"
    echo "${BATTERY_STATUS}%"
fi

