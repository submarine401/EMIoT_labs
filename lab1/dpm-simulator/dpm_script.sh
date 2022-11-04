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
    echo "  Usage: ./dmp_script_wl1.sh [destination file tag] [setting]"
    echo "      -destination file tag"
    echo "          string to be attached to default filename"
    echo "      -setting"
    echo "          ri : read-idle setting"
    echo "          rs : read-sleep setting"
}

if [[ $# -lt 2 ]]
then
    echo "[ERROR]: missing argument, 2 needed."
    usage_info
    exit 1
fi

# reads input argument to set correct destination filename
if [[ $2 = "ri" ]]
then
    dest_filename="dpmres_wl${1}_run_idle.txt";  # RUN-IDLE POLICY setup
elif [[ $2 = "rs" ]]
then
    dest_filename="dpmres_wl${1}_run_sleep.txt";  # RUN-SLEEP POLICY setup
else
    echo "[ERROR]: missing or wrong argument."
    usage_info
    exit 1
fi

#declare the number of iterations
fine_iter=1000
coarse_iter=130

# builds simulation files
make

# starts fine-grained simulation cycles
printf "\n"
echo -n "" > $dest_filename
for ((i=0; i < $fine_iter; i++));
do
    prog $((i+1)) $fine_iter Fine-grained phase
	echo -n "$((i)) " >> $dest_filename
	./dpm_simulator -t $((i)) -psm example/psm.txt -wl ../workloads/workload_${1}.txt | grep -o "Energy w DPM = "[0-9]*.[0-9]* | grep -o "[0-9]*.[0-9]*$" >> $dest_filename
done

printf "\nDone.\n\n"

# starts coarse-grained simulation cycles
for ((i=1; i <= $coarse_iter; i++));
do
    prog "$i" $coarse_iter Coarse-grained phase
    echo -n "$((i*1000)) " >> $dest_filename
    ./dpm_simulator -t $((i*1000)) -psm example/psm.txt -wl ../workloads/workload_${1}.txt | grep -o "Energy w DPM = "[0-9]*.[0-9]* | grep -o "[0-9]*.[0-9]*$" >> $dest_filename 
done

printf "\nDone.\n\n"
