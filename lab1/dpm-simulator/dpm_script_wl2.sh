#simple script for automatizing simulation of the timeout DPM policy

#declase number of iterations

prog() {
    local w=45 p=$1 tot=$2;  shift
    # create a string of spaces, then change them to dots
    printf -v dots "%*s" "$(( $p*$w/$tot ))" ""; dots=${dots// /.};
    # print those dots on a fixed-width space plus the percentage etc. 
    printf "\r\e[K|%-*s| %3d %% %s" "$w" "$dots" "$p" "$*"; 
}

# reads input argument to set correct destination filename
if [[ $1 = "ri" ]]
then
    dest_filename="dpmres_wl2_run_idle.txt";  # set for RUN-IDLE POLICY
elif [[ $1 = "rs" ]]
then
    dest_filename="dpmres_wl2_run_sleep.txt";  # set for RUN-SLEEP POLICY
else
    echo "[ERROR]: missing or wrong argument. Usage:"
    echo "  ri : read-idle setting"
    echo "  rs : read-sleep setting"
    exit 1
fi

fine_iter=1000
coarse_iter=130
make
printf "\n"
echo -n "" > $dest_filename
for ((i=0; i < $fine_iter; i++));
do
    prog $((i+1)) $fine_iter Fine-grained phase
	echo -n "$((i)) " >> $dest_filename
	./dpm_simulator -t $((i)) -psm example/psm.txt -wl ../workloads/workload_2.txt | grep -o "Energy w DPM = "[0-9]*.[0-9]* | grep -o "[0-9]*.[0-9]*$" >> $dest_filename
done

printf "\nDone.\n\n"

for ((i=1; i <= $coarse_iter; i++));
do
    #echo "SIMULATION NO. $((i+1)) STARTED"
    prog "$i" $coarse_iter Coarse-grained phase
    echo -n "$((i*1000)) " >> $dest_filename
    ./dpm_simulator -t $((i*1000)) -psm example/psm.txt -wl ../workloads/workload_2.txt | grep -o "Energy w DPM = "[0-9]*.[0-9]* | grep -o "[0-9]*.[0-9]*$" >> $dest_filename
    #echo "SIMULATION NO. $((i+1)) ENDED"
    #echo "========================="
done

printf "\nDone.\n\n"
