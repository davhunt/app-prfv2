#!/usr/bin/env python3

import sys

import numpy as np
import nibabel as nib

# combines fMRI runs into single image for preprocessing

fmri = {}
arr = {}
sumTR = 0
for i in range(1,len(sys.argv)):
  nii_img = nib.load(sys.argv[i])
  key = "nii" + str(i)
  fmri[key] = nii_img
  arr[key] = nii_img.get_fdata()
  sumTR = sumTR + fmri[key].header['dim'][4] # get total #imgs in concatenated time-series

arr_cat = np.concatenate(list(arr.values()),3)

fmri_cat = nib.Nifti1Image(arr_cat, fmri["nii1"].affine, fmri["nii1"].header)
fmri_cat.header['dim'][4] = sumTR

nib.save(fmri_cat,'bold_cat.nii.gz')
