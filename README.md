<h1 align="center">pRFLife with mrTools</h1>

<p align="center">
  Estimates voxel-wise population receptive fields (polar angle, eccentricity, size, R2) from retinotopy fMRI and its stimulus with the mrTools pRF model.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.315"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.315-blue.svg" alt="Run on brainlife.io"></a>
</p>

## At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Estimates voxel-wise population receptive fields (polar angle, eccentricity, size, R2) from retinotopy fMRI and its stimulus with the mrTools pRF model.**

Fits the mrTools pRF model to each voxel of the fMRI time series given the stimulus aperture. Voxels are restricted to the provided mask or, if none, to the FreeSurfer cortical ribbon in the selected lobes (occipital by default). fMRI can optionally be slice-time and motion corrected and globally regressed. The stimulus must match the fMRI timing.

| | |
|---|---|
| **Inputs** | `neuro/func/task` · `neuro/stimulus` · `neuro/freesurfer` · `neuro/mask` (optional) |
| **Outputs** | `neuro/prf` |
| **Container** | `brainlife/freesurfer:6.0.0` |
| **Resources** | 12 CPUs · 120 GB memory · 1 h walltime |
| **Requires** | `FREESURFER_LICENSE` |
| **Run it** | [doi.org/10.25663/brainlife.app.315](https://doi.org/10.25663/brainlife.app.315) |

#### Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `fMRI` | `neuro/func/task` | yes | Retinotopy task fMRI time series (bold). |
| `stim` | `neuro/stimulus` | yes | Stimulus aperture as a pixelsX x pixelsY x time NIfTI with values in [0,1]. Must match the temporal dimension (TR) of the fMRI. |
| `freesurfer` | `neuro/freesurfer` | yes | FreeSurfer subject directory, used to build the cortical mask and surfaces. |
| `mask` | `neuro/mask` | no | Optional mask in fMRI space restricting the voxels analysed (for example V1). |

#### Outputs

| Output | Datatype | Description |
|---|---|---|
| `prf` | `neuro/prf` | pRF maps (r2, polar angle, eccentricity, receptive field size) as NIfTI, plus surface VTKs. |

<details>
<summary><b>Parameters</b> (10)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `frontal` | boolean | `false` | Include frontal cortex in mask |
| `temporal` | boolean | `false` | Include temporal cortex in mask |
| `parietal` | boolean | `false` | Include parietal cortex in mask |
| `occipital` | boolean | `true` | Include occipital cortex in mask |
| `preprocess` | boolean | `true` | Perform slice timing and head motion correction on fMRI before running prf |
| `TR` | number |  | Repetition time of fMRI (read from the nii header if unspecified) |
| `stimsizeX` | number | `16` | Width in degrees subtended of visual stimulus (16° for HCP) |
| `stimsizeY` | number | `16` | Height in degrees subtended of visual stimulus (16° for HCP) |
| `gsr` | enum | `none` | Specifies whether global signal regression (GSR) on input fMRI should be done, conversion to % change from baseline Options: `none`, `pvn`, `gms`. |
| `quickFit` | boolean | `false` | Only do the grid search that finds approximately good parameters for the model and will not optimize with the nonlinear search. This will speed up the program but will not produce optimized fits. |

</details>

<!-- brainlife-app:end -->

## Running the App

### On brainlife.io

Open the App at [doi.org/10.25663/brainlife.app.315](https://doi.org/10.25663/brainlife.app.315), choose `neuro/func/task`, `neuro/stimulus`, `neuro/freesurfer`, `neuro/mask` from your project, set the parameters and press **Execute**. The results are saved to your project as `neuro/prf`.

### Locally

You need [Singularity/Apptainer](https://apptainer.org/) (the App runs in `brainlife/freesurfer:6.0.0`), [`jq`](https://jqlang.github.io/jq/), `FREESURFER_LICENSE`.

1. Clone this repository.
2. Create `config.json` with the paths to your inputs and the parameters:

   ```json
   {
       "fmri": "/path/to/fMRI/fmri",
       "events": "/path/to/fMRI/events",
       "events_json": "/path/to/fMRI/events_json",
       "sbref": "/path/to/fMRI/sbref",
       "sbref_json": "/path/to/fMRI/sbref_json",
       "physio": "/path/to/fMRI/physio",
       "physio_json": "/path/to/fMRI/physio_json",
       "stim": "/path/to/stim/stim",
       "output": "/path/to/freesurfer/output",
       "mask": "/path/to/mask/mask",
       "frontal": false,
       "temporal": false,
       "parietal": false,
       "occipital": true,
       "preprocess": true,
       "TR": "",
       "stimsizeX": 16,
       "stimsizeY": 16,
       "gsr": "none",
       "quickFit": false
   }
   ```

3. Run `./main`.

## Troubleshooting

- **Please set FREESURFER_LICENSE in .bashrc**: Provide a FreeSurfer license (FREESURFER_LICENSE).
- **output missing**: Check the fMRI, stimulus and mask inputs and the MATLAB log.

## For HCP subjects

HCP subject voxel-wise fMRI data can be downloaded from db.humanconnectome.org.

In a 7T subject's "7T_RET_fixextended" folder, preprocessed retinotopy BOLD data can be found at: MNINonLinear/Results/tfMRI_7T_RETCCW_AP_RETCW_PA_RETEXP_AP_RETCON_PA_RETBAR1_AP_RETBAR2_PA/tfMRI_7T_RETCCW_AP_RETCW_PA_RETEXP_AP_RETCON_PA_RETBAR1_AP_RETBAR2_PA_hp2000_clean.nii.gz

## Citing

If you use this App, please cite it, the software it builds on and brainlife.io:

- pRFLife with mrTools. brainlife.io App. [doi:10.25663/brainlife.app.315](https://doi.org/10.25663/brainlife.app.315)
- Gardner JL, Merriam EP, Schluppeck D, Besle J, Heeger DJ. mrTools: Analysis and visualization package for functional magnetic resonance imaging data (Version 4.7). Zenodo (2018).
- Gardner, Justin L., Merriam, Elisha P., Schluppeck, Denis, Besle, Julien, & Heeger, David J. (2018, June 28). mrTools: Analysis and visualization package for functional magnetic resonance imaging data (Version 4.7). Zenodo. [http://doi.org/10.5281/zenodo.1299483](http://doi.org/10.5281/zenodo.1299483)
- Fischl. FreeSurfer. *NeuroImage* 62:774-781 (2012). [doi:10.1016/j.neuroimage.2012.01.021](https://doi.org/10.1016/j.neuroimage.2012.01.021)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. *Scientific Data* 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## Authors

- Justin Gardner
- David Hunt

**Project director**

- Franco Pestilli

## Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io, which runs this App, is publicly funded by Wellcome, the U.S. National Institutes of Health and the U.S. National Science Foundation; acknowledging that support helps keep it running.</sub>
