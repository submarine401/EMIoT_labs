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
    echo "	-destination file"
    echo "		filename containing significant result of the simulations"
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

#declare number of iterations
sleep_threshold=350

#build simulation files
make

#call the dpm_simulator with variable sleep_thresholds
for i in {10..350..10}
do
    prog "$i" $sleep_threshold Sleep threshold phase
    	echo -n "$((i)) " >> $1
    	./dpm_simulator -h $2 $3 $((i)) -psm example/psm.txt -wl ../workloads/workload_1.txt | grep -o "Energy w DPM = "[0-9]*.[0-9]* | grep -o "[0-9]*.[0-9]*$" >> $1
done

printf "\nDone.\n\n"
