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
    echo "Usage: ./dpm_hystory_script.sh [destination file tag] [regression coefficients] [thresholds]"
    echo "	-wokload and destination tag"
    echo "		string to be attached to default filename and denoting the workload under analysis"
    echo "	-regression coefficients"
    echo "		numeric values for history policy using non-linear regression (currently supporting only 1 value)"
    echo "	-thresholds"
    echo "		numeric values for threshold-based predictive policy (currently 2 values are required)"
}

#check number of arguments provided
if [[ $# -lt 3 ]]
then
    echo "[ERROR]:  missing arguments, 3 required."
    usage_info
    exit 1
fi

#clear destination file if already existent
> dpmres_history_threshold_wl_$1.txt

#declare number of iterations
sleep_threshold=50
idle_threshold=50

#build simulation files
make

#call the dpm_simulator with variable sleep_thresholds
for i in {1..50..1}
do
    prog "$i" $sleep_threshold Sleep threshold phase
    	echo -n "$((i)) " >> dpmres_history_threshold_wl_$1.txt
    	./dpm_simulator -h $2 $3 $((i)) -psm example/psm.txt -wl ../workloads/workload_1.txt | grep -o "Energy w DPM = "[0-9]*.[0-9]* | grep -o "[0-9]*.[0-9]*$" >> dpmres_history_threshold_wl_$1.txt
done

printf "\nDone.\n\n"
