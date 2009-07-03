#!/bin/bash
#3 hours of freetime between 2:00 AM and 7:00 AM eastern
#or 11:00 pm and 4:00 am pacific 


# Wait till theGoldenHour
# this can run concurrently with HughesGet.sh since this uses primarily uplink, HughesGet.sh downlink
# get a list of files to upload
# 
# for each file i
#    scp $i redinger@redingerdressage.com:/home/redinger/incoming
#       if upload was a success 
#         move the file to Uploaded/
#      if it's 3 am or greater
#          quit
#          otherwise upload the next one
#  
yourtarget="redinger@redingerdressage.com:/home/redinger/incoming"

#include the checktime() subroutine
. $base/lib/timer.lib


#wait till 11 pm
#show progress once per minute
#Data downloaded between 3:00 AM and 6:00 AM Eastern Time, prior to 11/10/08
#and between 2:00 AM and 7:00 AM Eastern Time after 11/10/08 
#will not apply towards your service plan's download threshold.
#Please see the FAQs for additional information. 
hr=`date +%H`
m=`date +%M`
timenow=`expr $hr \*  60 + $m `
starttime=`expr 22 \* 60`  
waittime=`expr $starttime - $timenow  `

echo "$timenow,$starttime,$waittime"
for i in `seq $waittime`
do
   timeleft=`expr $waittime - $i` 
   echo " $timeleft minutes till uploads..."
   sleep 1m
done 

#start a watchdog timer that will kill scp  in 5 hours
#the scp will fail out, and checktime will exit(0)... 
(sleep 5h;killall scp )&

checktime

echo `date`" Starting Uploads" >> $base/log/HughesPut.log


echo "Starting Uploads"

done=0
if [ $done -eq 0  ]
then
    files=`ls /home/george/Desktop/mp3/toUpload`
    echo "files = $files"
    echo `date`"done=0,reading \$files" >> $base/log/HughesPut.log 
else
    echo `date`" done=1,not reading \$files" >> $base/HughesPut.log
fi

for file in $files
do
   echo   `date` "uploading $file"
   echo `date` "uploading $file" >> $base/log/HughesPut.log
   echo `du -h $file` >> $base/log/HughesPut.log
   scp $base/toUpload/$file $yourtarget   
   scpresult=$?
   # if it was a success, move the  file to ./Uploaded
   echo `date` "scp returned $scpresult"
   echo `date` "scp returned $scpresult" >> $base/log/HughesPut.log
   if [  $scpresult -eq "0" ]
   then
        mv $base/toUpload/$file $base/Uploaded
        echo "mv $base/toUpload/$file $base/Uploaded"
   fi

checktime

done

