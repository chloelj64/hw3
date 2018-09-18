docker run -it --rm -v $HOME/design_test:/bind rhancock/burc-lite /bin/bash

loops=$1
results_lines=/bind/hw3/results/efficiencies
rm $results_lines

for i in `seq $loops`
do

output_file=/bind/hw3/times/3dDeconvolve_$i.output_file
make_random_timing.py -num_stim 3 -num_runs 1 \
-run_time 300 \
-stim_labels A B C \
-num_reps 20 \
-prefix stimt \
-stim_dur 2 \
-min_rest 1 \
-max_rest 5 \
-seed $i 
-max_consec 1 \


pwd
ls -l

3dDeconvolve -nodata 300 1 -polort 1 -num_stimts 3 -stim_times 1 stimt_01_A.1D 'GAM' -stim_label 1 'A' \
		-stim_times 2 stimt_02_B.1D 'GAM' -stim_label 2 'B' \
		-stim_times 3 stimt_03_C.1D 'GAM' -stim_label 3 'C' \
		-gltsym "SYM: A -B" -gltsym "SYM: A -C"> $output_file

	efficiency=`/bind/hw3/scripts/efficiency_parser.py $output_file`
	echo "$efficiency $i" >> $results_lines
done