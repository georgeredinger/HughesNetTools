#!/bin/bash
#runs before getting urls from url list 
#from HughesGet.sh
. /home/george/Desktop/mp3/timer.lib

base="/home/george/Desktop/mp3"
log="$base/PreGet.log"
echo `date`"Start PreGet.sh" >> $log
#if [ ! -f /home/george/Desktop/mp3/lm_dat_01_full.wmv ]
#then
#mplayer -dumpstream -dumpfile /home/george/Desktop/mp3/lm_dat_01_full.wmv mms://media.scctv.net/annenberg/lm_dat_01_full.wmv
#fi
#checktime

cd $base

echo `date` "end of Preget.sh" >> $log
