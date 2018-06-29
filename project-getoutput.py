import imageio
import numpy
import argparse
import os, shutil

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('--project', metavar='dir', type=str,
                    help='Project directory', required=True)
parser.add_argument('--output', metavar='file', type=str,
                    help='Output base name', required=True)

args = parser.parse_args()

#Copy texture
shutil.copy(os.path.join(args.project,'openmvs','model_dense_mesh_refine_texture.png'), args.output+'.png')

#Copy file, updating texture name
in_data = open(os.path.join(args.project,'openmvs','model_dense_mesh_refine_texture.ply'), 'rb').read()
out_file = open(args.output+'.ply', 'wb')

end_header_position = in_data.index(b'end_header') + 10
header_data = in_data[:end_header_position].decode('ascii')

for line in header_data.split('\n'):
    if line.startswith('comment TextureFile'):
        line = 'comment TextureFile ' + os.path.basename(args.output)
    out_file.write(line.encode('ascii')+b'\n')
    
out_file.write(in_data[end_header_position+1:])
out_file.close()
