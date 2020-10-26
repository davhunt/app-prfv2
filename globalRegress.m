function [denoised_data] = globalRegress(data, gsrtype)

  if strcmp(gsrtype, 'pvn')
    denoised_data = cell(1,size(data,2));
    for p = 1:size(data,2)
      denoised_data{p} = zeros(size(data{p}));
      for i = 1:size(data{p},1)
        for j = 1:size(data{p},2)
          for k = 1:size(data{p},3)
            voxelBaseline = mean(data{p}(i,j,k,:)); % calculate per voxel mean signal over run
            denoised_data{p}(i,j,k,:) = (data{p}(i,j,k,:) - voxelBaseline) / voxelBaseline * 100; % convert to %signal change from baseline
            % voxels with mean 0 signal will be NaNs
          end
        end
      end
      denoised_data{p}(denoised_data{p} > 1000) = NaN; % try to exclude absurd values
    end
  elseif strcmp(gsrtype, 'gms')
    denoised_data = cell(1,size(data,2));
    for p = 1:size(data,2)
      denoised_data{p} = zeros(size(data));
      globalMean = mean(data{p}(data{p}~=0), 'all'); % calculate mean of all voxels+time points (not counting 0s)
      denoised_data{p} = (data{p} - globalMean) / globalMean * 100; % convert to %signal change from baseline
    end
    denoised_data{p}(denoised_data{p} == -100) = NaN; % make voxels outside the brain NaNs
  else
    denoised_data = data;
  end
end
