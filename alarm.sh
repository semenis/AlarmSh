#!/bin/bash

#Чтобы поставить будильник, вводим в терминале команду "crontab -e"
#И прописываем нужные параметры:
## m h  dom mon dow   command
#0 7 * * 1-5 ./alarm.sh
#0 10 * * 6-7 ./alarm.sh


export DISPLAY=:0
export LANG=ru_RU.UTF-8


# Выбираем нужный синтезатор речи, раскомментировав одну из строк:
#sayit () { espeak -vru -s130; }
sayit () { festival --tts --language russian; }
#sayit () { festival_client --ttw | aplay -q; }
#sayit () { RHVoice | aplay -q; }


# Склоняем в соответствующем падеже слова "час" и "минута"

check_date ()

{

HOUR=`date +%H`
MIN=`date +%M`

if [[ "$HOUR" = 1[1234] || "$HOUR" = ?[056789] ]]; then LC_HOUR="часов"
elif [[ "$HOUR" = ?[234] ]]; then LC_HOUR="час+а"
elif [[ "$HOUR" = ?1 ]]; then LC_HOUR="час"
else LC_HOUR="значение не определено"
fi

if [[ "$MIN" = 1[1234] || "$MIN" = ?[056789] ]]; then LC_MINUTE="минут"
elif [[ "$MIN" = ?[34] ]]; then LC_MINUTE="минуты"
else LC_MINUTE="значение не определено"
fi

if [[ "$MIN" = 01 ]]; then TIME="$HOUR $LC_HOUR однa минута"
elif [[ "$MIN" = 11 ]]; then TIME="$HOUR $LC_HOUR $MIN $LC_MINUTE"
elif [[ "$MIN" = ?1 ]]; then TIME="$HOUR $LC_HOUR $(($MIN-1)) одна минута"
elif [[ "$MIN" = 02 ]]; then TIME="$HOUR $LC_HOUR две минуты"
elif [[ "$MIN" = 12 ]]; then TIME="$HOUR $LC_HOUR $MIN $LC_MINUTE"
elif [[ "$MIN" = ?2 ]]; then TIME="$HOUR $LC_HOUR $(($MIN-2)) две минуты"
elif [[ "$MIN" = 00 ]]; then TIME="$HOUR $LC_HOUR ровно"
else TIME="$HOUR $LC_HOUR $MIN $LC_MINUTE"
fi

if [[ "$HOUR" = 08 ]] || [[ "$HOUR" -ge 06 && "$HOUR" -le 11 ]]; then
HELLO="Доброе утро"
elif [[ "$HOUR" -ge 12 && "$HOUR" -le 17 ]]; then
HELLO="Добрый день"
elif [[ "$HOUR" -ge 18 && "$HOUR" -le 23 ]]; then
HELLO="Добрый вечер"
elif [[ "$HOUR" -ge 00 && "$HOUR" -le 05 ]]; then
HELLO="Доброй ночи"
else HELLO="Привет"
fi

}



# начальная громкость, в процентах
VOLUME=25
# конечная (максимальная) громкость, в процентах
MAXVOLUME=65


# А теперь сам будильник

amixer -q sset Master $VOLUME% unmute
if [[ `ps h -C rhythmbox` ]]
then sleep 10
else rhythmbox &> /dev/null & sleep 10
fi
rhythmbox-client --set-volume 0.9


rhythmbox-client --play-uri="http://online.radiorecord.ru:8102/tm_128" #Можно и радио послушать
rhythmbox-client --set-volume 0.9
#while [[ "$VOLUME" -le "$MAXVOLUME" ]]
#do
#VOLUME=$(($VOLUME+1))
#sleep 1
#amixer -q sset Master $VOLUME% unmute
#done



#echo "1"
sleep 5
#echo "2"

rhythmbox-client --set-volume 0.9
sleep 1
rhythmbox-client --set-volume 0.8
sleep 1
rhythmbox-client --set-volume 0.7
sleep 1
rhythmbox-client --set-volume 0.6
sleep 1
rhythmbox-client --set-volume 0.5
sleep 1
rhythmbox-client --set-volume 0.4

check_date
echo "$HELLO, товарищ " | sayit
echo "Я надеюсь, что вы хорошо спали?" | sayit
echo "Сегодня `date +%A`" | sayit
echo "Время $TIME" | sayit

python3 weather.py | sayit
echo "Желаю вам удач+нава дня" | sayit

rhythmbox-client --set-volume 0.5
sleep 1
rhythmbox-client --set-volume 0.6
sleep 1
rhythmbox-client --set-volume 0.7
sleep 10
rhythmbox-client --set-volume 0.8
sleep 1
rhythmbox-client --set-volume 0.7
sleep 1
rhythmbox-client --set-volume 0.6
sleep 1
rhythmbox-client --set-volume 0.5
sleep 1
killall rhythmbox
exit 0
