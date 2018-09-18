docker run -it --rm -v $HOME/design_test:/bind rhancock/burc-lite /bin/bash

loops=$1
results_lines=/bind/hw3/results/efficiencies
rm $results_lines
for i in `seq $loops`
do
	output_file=/bind/hw3/times/3dDeconvolve_$i.output_file
	RSFgen -nt 300 -num_stimts 3 -nreps 1 20 -nreps 2 20 -nreps 3 20 -seed $i -prefix stim_ 
	make_stim_times.py -files stim_*.1D -prefix stimt -nt 300 -tr 1 -nruns 1
	3dDeconvolve -nodata 300 1 -polort 1 -num_stimts 3 -stim_times 1 stimt.01.1D 'GAM' -stim_label 1 'A' \
		-stim_times 2 stimt.02.1D 'GAM' -stim_label 2 'B' \
		-stim_times 3 stimt.03.1D 'GAM' -stim_label 3 'C' \
		-gltsym "SYM: A -B" -gltsym "SYM: A -C" > $output_file
	efficiency=`/bind/hw3/scripts/efficiency_parser.py $output_file`
	echo "$efficiency $i" >> $results_lines
done
