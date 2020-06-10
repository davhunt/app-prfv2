function getPRF(fmri,stim,mask,stimsize)

data = [];
nii = load_untouch_nii(fmri);
data = double(nii.img);

%stimulus = {};
%a1 = load_untouch_nii(stim);
%stimulus{1} = double(a1.img);

%pxtodeg = 16.0/200;

maskBool = [];
maskedData = [];
a1 = load_untouch_nii(mask);
maskBool = double(a1.img);

for i = 1:size(data,1)
  for j = 1:size(data,2)
    for k = 1:size(data,3)
      if maskBool(i,j,k) >= 1.0
        maskBool(i,j,k) = 1.0;	% create binary mask
      end
    end
  end
end
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

%maskedNii = make_nii(maskedData);
maskedNii = nii;

maskedNii.img = double(maskedData);
%maskedNii.hdr.dime.dim(1) = 3;
%maskedNii.hdr.dime.dim(5) = 1;
maskedNii.hdr.dime.datatype = 64; %FLOAT64 img
maskedNii.hdr.dime.bitpix = 64;
maskedNii.hdr.dime.dim = [4 numRows numColumns 1 size(data,4) 1 1 1];

save_untouch_nii(maskedNii,'./maskedNii.nii.gz')
maskedNiiPath = fullfile(cwd,'maskedNii.nii.gz');

%results = analyzePRF(stimulus,maskedData,1,struct('seedmode',[-2],'display','off'));
results = mlrRunPRF(cwd,maskedNiiPath,stim,stimsize,'quickFit=0','doParallel=12');
%evalc(char("results = mlrRunPRF(cwd,maskedNiiPath,stim,stimsize,'quickFit=1','doParallel=12');")); % problems with displaying output to command window
%evalc("results = mlrRunPRF(cwd,maskedNiiPath,stim,stimsize,'quickFit=1','doParallel=12');");

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

nii.hdr.dime.dim(1) = 3;
nii.hdr.dime.dim(5) = 1;
nii.hdr.dime.datatype = 64; %FLOAT64 img
nii.hdr.dime.bitpix = 64;

nii.img = polarAngle;
save_untouch_nii(nii,['prf/polarAngle.nii.gz']);

nii.img = eccentricity;
save_untouch_nii(nii,['prf/eccentricity.nii.gz']);

nii.img = rfWidth;
save_untouch_nii(nii,['prf/rfWidth.nii.gz']);

nii.img = r2;
save_untouch_nii(nii,['prf/r2.nii.gz']);

end
