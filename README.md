# sfm-bundle

Bundle of scripts to create and use a SFM/photogrammetry workflow

## Installing

Build requirements:
```
apt install cmake libceres-dev libboost-all-dev libfreeimage-dev libglew-dev qtbase5-dev libopencv-dev libcgal-dev
```

Runtime requirements:
```	
apt install libgoogle-glog0v5 libfreeimage3 libceres1 libqt5opengl5 libqt5widgets5 libglew2.0 libboost-iostreams1.62 libboost-program-options1.62 libboost-system1.62 libboost-serialization1.62 libboost-regex1.62 libopencv-calib3d2.4v5 libopencv-contrib2.4v5 libopencv-core2.4v5 libopencv-features2d2.4v5 libopencv-flann2.4v5 libopencv-gpu2.4v5 libopencv-highgui2.4-deb0 libopencv-imgproc2.4v5 libopencv-legacy2.4v5 libopencv-ml2.4v5 libopencv-objdetect2.4v5 libopencv-ocl2.4v5 libopencv-photo2.4v5 libopencv-stitching2.4v5 libopencv-superres2.4v5 libopencv-ts2.4v5 libopencv-video2.4v5 libopencv-videostab2.4v5 libcgal12 	libgmpxx4ldbl
```

## Input

Two folders:
- `images`
- `images-nobg` (images with background removed)
