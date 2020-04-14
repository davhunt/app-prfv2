#!/bin/bash

fslroi ${1} fMRI_slice.nii.gz 0 1 # extract first (t=0) volume from fMRI

flirt -in T1.nii.gz -ref fMRI_slice.nii.gz -out fs2func.nii.gz -omat fs2func.mat # register T1 to fMRI

fslmaths aparc+aseg.nii.gz -uthr 2029 -thr 2029 aseg.visual.nii.gz # extract ROIs of interest

fslmaths aseg.visual.nii.gz -bin aseg.visual.nii.gz

flirt -in aseg.visual.nii.gz -ref fs2func.nii.gz -out prob_mask.nii.gz -init fs2func.mat -applyxfm

fslmaths prob_mask.nii.gz -thr 0.2 -bin mask.nii.gz
