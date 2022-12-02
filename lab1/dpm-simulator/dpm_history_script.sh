#!/bin/bash
#simple script for automatizing simulation of the timeout DPM policy

# simple progress bar function
prog() {
    local w=45 p=$1 tot=$2;  shift
    # create a string of spaces, then change them to dots
    printf -v dots "%*s" "$(( $p*$w/$tot ))" ""; dots=${dots// /.};
    # print those dots on a fixed-width space plus the percentage etc. 
    printf "\r\e[K|%-*s| %3d %% %s" "$w" "$dots" "$p" "$*"; 
}

# prints usage info on terminal
usage_info() {
    echo "Usage: ./dpm_hystory_script.sh [destination file tag] "
    echo "[regression coefficients] [thresholds]"
    echo "WARNING: currently the only supported history policy "
    echo "is the threshold one"
    echo "	-wokload and destination tag"
    echo "		string to be attached to default filename" 
    echo "and denoting the workload under analysis"
    echo "	-regression coefficients"
    echo "		numeric values for history policy "
    echo "using non-linear regression (currently "
    echo "supporting only 1 value)"
    echo "	-thresholds"
    echo "		numeric values for threshold-based "
    echo "predictive policy (currently 2 values are required)"
}

#check number of arguments provided
if [[ $# -lt 4 ]]
then
    echo "[ERROR]:  missing arguments, 4 required."
    usage_info
    exit 1
fi

#clear destination file if already existent
> dpmres_history_idle_threshold_wl_$1.txt
> dpmres_history_sleep_threshold_wl_$1.txt

#declare number of iterations
sleep_threshold=300
idle_threshold=50

#build simulation files
make

#call the dpm_simulator with a variable idle threshold
#the idle threshold is incremented by one until 
#it reaches the value of the sleep threshold
for (( i = 1; i <= $4; i++))
do
    prog "$i" $4 Idle threshold phase
    	echo -n "$((i)) " >> dpmres_history_idle_threshold_wl_$1.txt
    	./dpm_simulator -h $2 $((i)) $4 \
    	-psm example/psm.txt -wl ../workloads/workload_$1.txt | \
    	grep -o "Energy w DPM = "[0-9]*.[0-9]* |\
    	 grep -o "[0-9]*.[0-9]*$" >> \
    	 dpmres_history_idle_threshold_wl_$1.txt
done

#call the dpm_simulator with 
#variable sleep_thresholds
for i in {1..300..1}
do
    if [ $i -gt $3 ]
    then
    	prog "$i" $sleep_threshold Sleep threshold phase
    	echo -n "$((i)) " >> dpmres_history_sleep_threshold_wl_$1.txt
    	./dpm_simulator -h $2 $3 $((i)) \
    	 -psm example/psm.txt -wl ../workloads/workload_$1.txt | \
    	grep -o "Energy w DPM = "[0-9]*.[0-9]* | \
    	grep -o "[0-9]*.[0-9]*$" >> \
    	dpmres_history_sleep_threshold_wl_$1.txt
    fi
done

printf "\nDone.\n\n"
