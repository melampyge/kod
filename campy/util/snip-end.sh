# parameters: duration in seconds - 
mencoder -ss 00:00:00 -endpos 00:00:$2 -oac copy -ovc copy $1 -o part-$2.avi
