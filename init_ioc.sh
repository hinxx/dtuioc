#!/bin/bash

source $HOME/bin/ng3esetup.sh
which caget >/dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "caget not found in PATH!"
	exit 1
fi

caput    CCS1:det1:TlWavelengthDataTarget 0
caput    CCS1:det1:TlWavelengthDataGet 1
caget    CCS1:det1:TlWavelengthMinimum CCS1:det1:TlWavelengthMaximum
caput    CCS1:det1:TlAmplitudeDataMode 0
caput    CCS1:det1:TlAmplitudeDataTarget 2
caput    CCS1:det1:TlAmplitudeDataGet 1
caput    CCS1:trace1:EnableCallbacks 1
caput -S CCS1:HDF1:FilePath "/tmp"
caput -S CCS1:HDF1:FileName "spectra"
caput -S CCS1:HDF1:FileTemplate "%s%s_%3.3d.h5"
caput    CCS1:HDF1:AutoIncrement 1
caput    CCS1:HDF1:AutoSave 1
caput -S CCS1:HDF1:NDAttributesFile "CCS200Attributes.xml"

caput    CAM1:Stats1:EnableCallbacks 1
caput    CAM1:image1:EnableCallbacks 1
caput -S CAM1:HDF1:FilePath "/tmp"
caput -S CAM1:HDF1:FileName "image"
caput -S CAM1:HDF1:FileTemplate "%s%s_%3.3d.h5"
caput    CAM1:HDF1:AutoIncrement 1
caput    CAM1:HDF1:AutoSave 1
caput -S CAM1:HDF1:NDAttributesFile "mantaG235BAttributes.xml"