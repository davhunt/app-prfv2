#!/usr/bin/env python3

import sys

import numpy as np
import nibabel as nib

# splits preprocessed fMRI back into original runs

bold_cat = nib.load(sys.argv[1])
n = 0
fmri = {}

for i in range(0,len(sys.argv)-2):
  key = "nii" + str(i+1)
  fmri[key] = nib.load(sys.argv[i+2])
  lenFMRI = fmri[key].get_fdata().shape[3]

  data_arr = bold_cat.get_fdata()[:,:,:,n:n+lenFMRI]
  n = n+lenFMRI

  preproc_fmri = nib.Nifti1Image(data_arr, fmri[key].affine, fmri[key].header)
  nib.save(preproc_fmri,'preproc_bold_' + str(i+1) + '.nii.gz')
