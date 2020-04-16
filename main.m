function [] = main()

if ~isdeployed
	disp('loading paths for IUHPC')
	addpath(genpath('/N/u/brlife/git/jsonlab'))
	addpath(genpath('/N/u/brlife/git/vistasoft'))
	addpath(genpath('/N/u/davhunt/Carbonate/gru'))
	addpath(genpath('/N/u/davhunt/Carbonate/mgl'))
	addpath(genpath('/N/u/davhunt/Carbonate/mrTools'))
        addpath(genpath('/N/u/davhunt/Carbonate/Downloads/NIfTI_matlab_tools'))
end

% load my own config.json
config = loadjson('config.json');
if isfield(config,'mask')
  mask = config.mask;
else
  mask = fullfile(pwd,'mask.nii.gz');
end

% compute pRF
%getPRF(config.fmri, config.stim, mask, [16.0 16.0]);
getPRF('bold.nii.gz','stim.nii.gz',mask, [16.0 16.0]);

end
