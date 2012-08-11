# parameters: [hh:mm:ss] [ss]
echo "---------------------------------------------"
echo "File: $1"
echo "Start: $2"
echo "Duration: $3 seconds"
echo "---------------------------------------------"
mencoder -ss $2 -endpos $3 -oac copy -ovc copy $1 -o out.avi
