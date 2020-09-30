#!/bin/bash

module unload matlab && module load matlab/2017a

log=compiled/commit_ids.txt
true > $log
echo "/N/u/brlife/git/jsonlab" >> $log
(cd /N/u/brlife/git/jsonlab && git log -1) >> $log
echo "/N/u/davhunt/Carbonate/gru" >> $log
(cd /N/u/davhunt/Carbonate/gru && git log -1) >> $log
echo "/N/u/davhunt/Carbonate/mgl" >> $log
(cd /N/u/davhunt/Carbonate/mgl && git log -1) >> $log
echo "/N/u/davhunt/Carbonate/mrTools" >> $log
(cd /N/u/davhunt/Carbonate/mrTools && git log -1) >> $log
echo "/N/u/brlife/git/NIfTI" >> $log
(cd /N/u/davhunt/Carbonate/NIfTI_cifti_matlab_tools && git log -1) >> $log

mkdir -p compiled

cat > build.m <<END
addpath(genpath('/N/u/brlife/git/jsonlab'))
addpath(genpath('/N/u/davhunt/Carbonate/gru'))
addpath(genpath('/N/u/davhunt/Carbonate/mgl'))
addpath(genpath('/N/u/davhunt/Carbonate/mrTools'))
addpath(genpath('/N/u/brlife/git/NIfTI'))
mcc -m -R -nodisplay -a /N/u/brlife/git/vistasoft/mrDiffusion/templates -d compiled main
exit
END
matlab -nodisplay -nosplash -r build
