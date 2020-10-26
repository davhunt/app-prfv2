function getPRF(fmri, stim, mask, quickFit, TR, stimsizeX, stimsizeY, gsr)

if length(fmri) ~= length(stim)
  error('must input one stimulus for each fmri run')
end

if isempty(stimsizeX) || isempty(stimsizeY)    % size of stimulus in degrees
  error('size of visual stimulus in degrees not specified')
end

data = {};
stimulus = {};

for p=1:length(fmri)
  a1 = load_untouch_nii(char(fmri{p}));
  data{p} = a1.img;
  a1 = load_untouch_nii(char(stim{p}));
  stimulus{p} = a1.img;
end



data = cat(4, data{:}); % combine runs into 1 file
stimulus = cat(3, stimulus{:});

a1 = load_untouch_nii(char(stim{1}));
a1.hdr.dime.dim(4) = size(stimulus,3); % change # time points in header to combined total across runs
a1.img = stimulus;
save_untouch_nii(a1, './stim.nii.gz');
stimPath = fullfile(pwd,'stim.nii.gz');

a1 = load_untouch_nii(mask);
maskBool = a1.img;
maskBool(maskBool >= 1) = 1.0;	% create binary mask
maskBool = logical(maskBool);

[r,c,v] = ind2sub(size(maskBool),find(maskBool));


maskedData = zeros(size(r,1),size(data,4));
for i = 1:size(r,1)
  maskedData(i,:) = data(r(i),c(i),v(i),:);
end
%maskedData = squeeze(maskedData);
cwd = pwd;

numColumns = ceil(size(maskedData,1)/32767);
numRows = ceil(size(maskedData,1)/numColumns);
numLeftover = mod((numColumns*numRows),size(maskedData,1));
if numLeftover >= 1
  maskedData(size(r,1)+1:size(r,1)+numLeftover,:) = 0;
end
maskedData = reshape(maskedData,[numRows numColumns 1 size(data,4)]);

maskedData = globalRegress(maskedData, gsr); % do global signal regression if wanted

%maskedNii = make_nii(maskedData);
maskedNii = load_untouch_nii(char(fmri{1}));

if ~isempty(TR) && maskedNii.hdr.dime.pixdim(5) ~= TR % check for frame rate / repetition time in FMRI nifti
  warning(sprintf('TR in the fMRI nifti header %d does not match the TR inputted %d. Using TR inputted',maskedNii.hdr.dime.pixdim(5),TR))
  maskedNii.hdr.dime.pixdim(5) = TR;
end

maskedNii.img = double(maskedData);
%maskedNii.hdr.dime.dim(1) = 3;
%maskedNii.hdr.dime.dim(5) = 1;
maskedNii.hdr.dime.datatype = 64; %FLOAT64 img
maskedNii.hdr.dime.bitpix = 64;
maskedNii.hdr.dime.dim = [4 numRows numColumns 1 size(data,4) 1 1 1];

save_untouch_nii(maskedNii,'./maskedNii.nii.gz');
maskedNiiPath = fullfile(pwd,'maskedNii.nii.gz');

%results = analyzePRF(stimulus,maskedData,1,struct('seedmode',[-2],'display','off'));
results = mlrRunPRF(cwd,maskedNiiPath,stimPath,[stimsizeX stimsizeY],['quickFit=' num2str(quickFit)],'doParallel=12');

% one final modification to the outputs:
% whenever eccentricity is exactly 0, we set polar angle to NaN since it is ill-defined.
results.polarAngle(results.eccentricity(:)==0) = NaN;

% convert from radians to degrees, [-pi,pi] -> [0,360]
results.polarAngle(results.polarAngle(:)<0) = results.polarAngle(results.polarAngle(:)<0)+2*pi;
results.polarAngle = results.polarAngle*(180/pi);

[polarAngle, eccentricity, rfWidth, r2] = deal(zeros(size(data,1), size(data,2), size(data,3)));

c = 1; r = 1;
for k = 1:size(maskBool,3)
  for j = 1:size(maskBool,2)
    for i = 1:size(maskBool,1)
      if maskBool(i,j,k) >= 1.0
        polarAngle(i,j,k) = results.polarAngle(r,c);
        eccentricity(i,j,k) = results.eccentricity(r,c);
        rfWidth(i,j,k) = results.rfHalfWidth(r,c);
        r2(i,j,k) = results.r2(r,c);
        r = r+1; % increment to total voxels in mask
      else
        [polarAngle(i,j,k), eccentricity(i,j,k), rfWidth(i,j,k), r2(i,j,k)] = deal(NaN);
      end
      if r == numRows+1
        r = 1;
        c = c+1;
      end
    end
  end
end

nii = load_untouch_nii(char(fmri{1}));
%voxRes = a1.hdr.dime.pixdim(2:4) % voxel resolution of original fMRI
datatype = 64; % float64
origin = [0 0 0]; % voxels start at 0 0 0
%nii = make_nii(r2,voxRes,origin,datatype);

nii.hdr.dime.datatype = 64; nii.hdr.dime.bitpix = 64; % float64
nii.hdr.dime.dim(1) = 3; nii.hdr.dime.dim(5) = 1;
nii.hdr.dime.scl_slope = 0; nii.hdr.dime.scl_inter = 0;
nii.hdr.dime.glmax = 0; nii.hdr.dime.glmin = 0; % just set to 0


%nii.hdr.dime.pixdim(1) = a1.hdr.dime.pixdim(1); % should be 1 or -1?
%nii.hdr.dime.xyzt_units = a1.hdr.dime.xyzt_units; % millimeters x seconds

nii.img = polarAngle;
save_untouch_nii(nii,['prf/polarAngle.nii.gz']);

nii.img = eccentricity;
save_untouch_nii(nii,['prf/eccentricity.nii.gz']);

nii.img = rfWidth;
save_untouch_nii(nii,['prf/rfWidth.nii.gz']);

nii.img = r2;
save_untouch_nii(nii,['prf/r2.nii.gz']);

end
