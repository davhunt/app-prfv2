[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-brainlife.app.315-blue.svg)](https://doi.org/10.25663/brainlife.app.315)

# PRF analysis with mrTools

This app takes the time-series fMRI data of an individual subject performing a retinotopy task (bold.nii.gz), and derives voxel-wise pRF (population receptive field) measurements from their visual response to a stimulus (stim.nii.gz) using the [mrTools toolbox](https://github.com/justingardner/mrTools).

Visually responsive voxels (or grayordinates) are analyzed and properties of each grayordinate is extracted from the fMRI data.  PRF measurements include the grayordinate's r^2 (variance explained), receptive field angle, eccentricity, and size (std of the Gaussian).

[![pRF parameters](https://raw.githubusercontent.com/davhunt/pictures/master/Screenshot%20from%202019-04-17%2014-41-11.png)

A mask (mask.nii.gz) in the same dimensions as the fMRI bold image can be passed in (V1, for example) to specify which voxels to analyze. Otherwise the cortical ribbon between white and pial surfaces from the Freesurfer, in the lobes specified (default: occipital) will be used by default.

The stimulus stim.nii.gz must match the temporal dimension (TR) of the fMRI, and consists of a pixelsX x pixelsY x time-points NIfTI image with range [0,1] expressing the contrast of the stimulus image at each pixel over time.

The fMRI data can optionally be preprocessed with slice-timing correction and head motion correction.

Global signal regression of FMRI supported, converting signal to % change from baseline, either computing baseline for each voxel seperately (per-voxel normalization, 'pvn') or computing a global baseline (grand-mean scaling, 'gms').

### Authors
- Justin Gardner (jlg@stanford.edu)
- David Hunt (davhunt@indiana.edu)

### Project director
- Franco Pestilli (franpest@indiana.edu)

### Funding Acknowledgement
brainlife.io is publicly funded and for the sustainability of the project it is helpful to Acknowledge the use of the platform. We kindly ask that you acknowledge the funding below in your publications and code reusing this code.

[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-1636893](https://img.shields.io/badge/NSF_BCS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-ACI-1916518](https://img.shields.io/badge/NSF_ACI-1916518-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1916518)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://grantome.com/grant/NIH/R01-EB029272-01)

### Citations
We kindly ask that you cite the following articles when publishing papers and code using this code.

1. Gardner, Justin L., Merriam, Elisha P., Schluppeck, Denis, Besle, Julien, & Heeger, David J. (2018, June 28). mrTools: Analysis and visualization package for functional magnetic resonance imaging data (Version 4.7). Zenodo. [http://doi.org/10.5281/zenodo.1299483](http://doi.org/10.5281/zenodo.1299483)

1. Avesani, P., McPherson, B., Hayashi, S. et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. Sci Data 6, 69 (2019). [https://doi.org/10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

#### MIT Copyright (c) 2020 brainlife.io The University of Texas at Austin and Indiana University

## Running the App 

### For HCP subjects

HCP subject voxel-wise fMRI data can be downloaded from db.humanconnectome.org.

In a 7T subject's "7T_RET_fixextended" folder, preprocessed retinotopy BOLD data can be found at: MNINonLinear/Results/tfMRI_7T_RETCCW_AP_RETCW_PA_RETEXP_AP_RETCON_PA_RETBAR1_AP_RETBAR2_PA/tfMRI_7T_RETCCW_AP_RETCW_PA_RETEXP_AP_RETCON_PA_RETBAR1_AP_RETBAR2_PA_hp2000_clean.nii.gz

### On Brainlife.io

You can submit this App online at [https://doi.org/10.25663/brainlife.app.315](https://doi.org/10.25663/brainlife.app.315) via the "Execute" tab.

### Running Locally (on your machine)

1. git clone this repo.
2. Inside the cloned directory, create `config.json` with something like the following content with paths to your input files.

```json
{
    "frontal": false,
    "temporal": false,
    "parietal": false,
    "occipital": true,
    "preprocess": false,
    "TR": "",
    "stimsizeX": 16,
    "stimsizeY": 16,
    "gsr": "pvn",
    "quickFit": false,
    "fmri": [
      "testdata/run1/fmri/bold.nii.gz",
      "testdata/run2/fmri/bold.nii.gz",
      "testdata/run3/fmri/bold.nii.gz",
      "testdata/run4/fmri/bold.nii.gz"
    ],
    "events": [
      "testdata/run1/fmri/events.tsv",
      "testdata/run2/fmri/events.tsv",
      "testdata/run3/fmri/events.tsv",
      "testdata/run4/fmri/events.tsv"
    ],
    "stim": [
      "testdata/run1/stim/stim.nii.gz",
      "testdata/run2/stim/stim.nii.gz",
      "testdata/run3/stim/stim.nii.gz",
      "testdata/run4/stim/stim.nii.gz"
    ],
    "output": "/testdata/output"
}
```

3. Launch the App by executing `main`

```bash
./main
```

## Output

All output files will be generated under the current working directory (pwd). The main output of this App is the "prf" directory which contains NIFTI files polarAngle, eccentricity, receptive field size (rfWidth), and R2 of each voxel.

### Dependencies

This App only requires [singularity](https://www.sylabs.io/singularity/) to run.

#### MIT Copyright (c) 2020 brainlife.io The University of Texas at Austin and Indiana University
