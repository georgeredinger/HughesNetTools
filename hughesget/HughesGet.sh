#!/bin/bash
#3 hours of freetime between 3:00 AM and 5:00 AM eastern
#or midnight and 3:00 am pacific 
#**Data downloaded between 3:00 AM and 6:00 AM Eastern Time, prior to 11/10/08
#and between 2:00 AM and 7:00 AM Eastern Time after 11/10/08 
#will not apply towards your service plan's download threshold.
#Please see the FAQs for additional information. 
#arg 1 is a file of urls to download between midnight and 3 
#
#
# Wait till midnight , now 11pm pst
# copy the url file to a backup file
# copy the url file to a notdownloaded file
# for each url 
#    wget the url
#       if download was a success 
#         remove the url from the notdownloaded file
#      if it's 3 am,now 4am  or greater
#          quit
#          otherwise download the next one
#  


#include the checktime() subroutine
. ../lib/timer.lib


#check for the command line arg
if [ $# != 1 ]; then
    echo "Usage: $0 path"
        exit 1
else
   base=$1
   urls="$base/urls/urls.urls"
   if [ -f urls ] 
   then
     done=0
	 echo "No Urls to get will run get scripts"
   else
     done=1
   fi

fi


echo `date`" input file $urls" >> $base/log/HughesGet.log

#wait till the "happy hour"
#show progress once per minute
hr=`date +%H`
m=`date +%M`
timenow=`expr $hr \*  60 + $m `
#starttime=`expr 22 \* 60` #11pm
starttime=`expr 20 \* 60` #11pm
waittime=`expr $starttime - $timenow  `


for i in `seq $waittime`
do
   timeleft=`expr $waittime - $i` 
   echo " $timeleft minutes till downloads $base."
   sleep 1m
done 

#start a watchdog timer that will kill wgets  in 3 hours
#the wgets will fail out, and checktime will exit(0)$base. 
(sleep 5h;killall wget )&

echo `date`" Starting PreGet.sh" >> $base/log/HughesGet.log

checktime >> $base/log/HughesGet.log

$base/preget/PreGet.sh

checktime >> $base/log/HughesGet.log

echo `date`" Starting Downloads" >> $base/log/HughesGet.log


echo "Starting Downloads"

done=0
if [ $done -eq 0  ]
then
   cp $urls $urls".bak"
   cp $urls $base/urls/notdownloaded.urls
    exec 3< $urls
    echo `date`"done=0,reading $urls" >> $base/log/HughesGet.log 
else
    echo `date`" done=1,not reading $urls" >> $base/log/HughesGet.log
fi

# read each url line from the file and wget it
 
 #disable url getting

 until [ $done -eq 1 ]
 do
   read <&3 url 
   if [ $? -ne  0 ]; then
     done=1
     continue
   fi
   echo   `date` "getting $url"
   echo `date` "getting $url" >> $base/log/HughesGet.log
   wget -P $base/downloaded -c -o $base/log/wget.log $url
   wgetresult=$?
   # if it was a success, remove the url from the file
   # and copy url to success.urls
   # if fails, save the url in failures.urls
   echo `date` "wget returned $wgetresult"
   echo `date` "wget returned $wgetresult" >> $base/log/HughesGet.log
   if [  $wgetresult -ne "0" ]
   then
	     head -1 $base/urls/notdownloaded.urls >> $base/urls/failures.urls
	else
	     head -1 $base/urls/notdownloaded.urls >> $base/urls/success.urls

   fi
         sed -i 1d  $base/urls/notdownloaded.urls 

checktime >> $base/log/HughesGet.log
    
done

echo "The End" 
echo `date` "The End" >> $base/log/HughesGet.log
cp  $base/urls/notdownloaded.urls $urls
echo "$base/notdownloaded.urls contains files not completely downloaded"




