COLMAP := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))/bin/colmap
OPENMVS := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))/bin/OpenMVS
images := $(wildcard images/im-*.jpg)
LD_LIBRARY_PATH := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))/lib

.EXPORT_ALL_VARIABLES:


colmap.db: $(images)
	$(COLMAP) feature_extractor --database_path colmap1.db --image_path images-nobg/ --SiftExtraction.use_gpu=0
	#$(COLMAP) exhaustive_matcher --database_path colmap1.db --SiftMatching.use_gpu=0
	$(COLMAP) sequential_matcher --database_path colmap1.db --SiftMatching.use_gpu=0
	mv colmap1.db colmap.db
	
sparse/0/cameras.bin sparse/0/images.bin sparse/0/points3D.bin sparse/0/project.ini: colmap.db
	mkdir -p sparse
	$(COLMAP) mapper --database_path colmap.db  --export_path sparse/ --image_path images-nobg/
	$(COLMAP) model_orientation_aligner --method TURNTABLE  --image_path images-nobg/ --input_path sparse/0 --output_path sparse/0

openmvs/model.nvm: sparse/0/cameras.bin sparse/0/images.bin sparse/0/points3D.bin sparse/0/project.ini
	mkdir -p openmvs
	$(COLMAP) model_converter --input_path sparse/0/  --output_path openmvs/model1.nvm --output_type NVM 
	sleep 1
	sed  "4,$(shell expr 3 + `sed -n 3p openmvs/model1.nvm`)s/^/..\/images\//" openmvs/model1.nvm > openmvs/model.nvm
	
openmvs/model.mvs: openmvs/model.nvm
	$(OPENMVS)/InterfaceVisualSFM -w openmvs/ -i model.nvm 
	
openmvs/model_dense.mvs: openmvs/model.mvs
	$(OPENMVS)/DensifyPointCloud -w openmvs/ -i model.mvs 
	
openmvs/model_dense_mesh.mvs: openmvs/model_dense.mvs
	$(OPENMVS)/ReconstructMesh -w openmvs/ model_dense.mvs 
	
openmvs/model_dense_mesh_refine.mvs: openmvs/model_dense_mesh.mvs
	$(OPENMVS)/RefineMesh -w openmvs/ model_dense_mesh.mvs 
	
openmvs/model_dense_mesh_refine_texture.mvs openmvs/model_dense_mesh_refine.ply openmvs/model_dense_mesh_refine_texture.png: openmvs/model_dense_mesh_refine.mvs
	$(OPENMVS)/TextureMesh -w openmvs/ model_dense_mesh_refine.mvs
