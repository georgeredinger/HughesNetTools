#!/bin/bash
 for i in * 
 do
   b=`echo $i | grep ".*\.mp3" | fgrep "?"`
   bp=`echo $b|sed "s/\?.*$//"`
   case $b in '') ;; *) mv $b $bp;; esac
    
 done

