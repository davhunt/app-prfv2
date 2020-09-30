function [] = main()

if ~isdeployed
	disp('loading paths for IUHPC')
	addpath(genpath('/N/u/brlife/git/jsonlab'))
	addpath(genpath('gru'))
	addpath(genpath('mgl'))
	addpath(genpath('mrTools'))
        addpath(genpath('/N/u/brlife/git/NIfTI'))
end

% load my own config.json
config = loadjson('config.json');
if isfield(config,'mask')
  mask = config.mask;
else
  mask = fullfile(pwd,'mask.nii.gz');
end

% compute pRF
getPRF(config.fmri, config.stim, mask, [16.0 16.0]); % TODO make configurable

end
