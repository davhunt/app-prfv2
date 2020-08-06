#!/bin/bash

fsdir=${1}

[[ $(jq -r .frontal config.json) == true ]] && frontalROIs="2003 2012 2014 2017 2018 2019 2020 2024 2027 2028 2032 \
  1003 1012 1014 1017 1018 1019 1020 1024 1027 1028 1032"
[[ $(jq -r .temporal config.json) == true ]] && tempROIs="2001 2006 2007 2009 2015 2016 2030 2033 2034 2035 \
  1001 1006 1007 1009 1015 1016 1030 1033 1034 1035"
[[ $(jq -r .parietal config.json) == true ]] && parietalROIs="2008 2017 2022 2025 2029 2031 \
  1008 1017 1022 1025 1029 1031"
[[ $(jq -r .occipital config.json) == true ]] && occipitalROIs="2005 2011 2013 2021 1005 1011 1013 1021"

mri_convert ${fsdir}/mri/T1.mgz ./T1.nii.gz
mri_convert ${fsdir}/mri/aparc+aseg.mgz ./aparc+aseg.nii.gz
mri_binarize --i aparc+aseg.nii.gz --o ctx_ribbon.nii.gz --match ${frontalROIs} ${tempROIs} ${parietalROIs} ${occipitalROIs}
mri_vol2vol --mov ctx_ribbon.nii.gz --targ preprocessed_bold_cat.nii.gz --interp nearest --regheader --o mask.nii.gz
