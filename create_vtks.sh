#!/bin/bash

fsdir=${1}

echo "creating vtks"
mkdir -p prf/surfaces
mris_convert --to-scanner $fsdir/surf/lh.white prf/surfaces/lh.white.vtk
mris_convert --to-scanner $fsdir/surf/rh.white prf/surfaces/rh.white.vtk
mris_convert --to-scanner $fsdir/surf/lh.pial prf/surfaces/lh.pial.vtk
mris_convert --to-scanner $fsdir/surf/rh.pial prf/surfaces/rh.pial.vtk
mris_convert --to-scanner $fsdir/surf/lh.sphere prf/surfaces/lh.sphere.vtk
mris_convert --to-scanner $fsdir/surf/rh.sphere prf/surfaces/rh.sphere.vtk
mris_convert --to-scanner $fsdir/surf/lh.inflated prf/surfaces/lh.inflated.vtk
mris_convert --to-scanner $fsdir/surf/rh.inflated prf/surfaces/rh.inflated.vtk
