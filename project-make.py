import imageio
import numpy
import argparse
import os

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('--input', metavar='image', type=str, nargs='+',
                    help='Images files to read', required=True)
parser.add_argument('--project', metavar='dir', type=str,
                    help='Project directory', required=True)
parser.add_argument('--consecutivesigma', type=float, default=2.0,
                    help='Number of standard deviations required between' + \
                    ' to consider the pixels of being part ofthe subject' + \
                    ' 0 to disable (default: 2).')
                    
args = parser.parse_args()

output_nobg = os.path.join(args.project, 'images-nobg')
output_normal = os.path.join(args.project, 'images')
if not os.path.exists(output_nobg):
    os.makedirs(output_nobg)
if not os.path.exists(output_normal):
    os.makedirs(output_normal)

images = numpy.array([imageio.imread(f) for f in args.input]).astype(numpy.float)
images_out = images.copy()

if args.consecutivesigma > 0:
    from skimage.morphology import convex_hull_image
    import scipy.ndimage.filters

    imdelta = numpy.abs(images[1:]-images[:-1]).sum(3) #Consecutive images should be similar, except on the sample
    imdeltag = scipy.ndimage.filters.gaussian_filter(imdelta, (0,10,10))

    for i in range(imdelta.shape[0]):
        images_out[i][~convex_hull_image(imdeltag[i] > args.consecutivesigma * imdeltag[i].std())] = 0

for i in range(imdelta.shape[0]):
    imageio.imwrite(os.path.join(output_nobg,'{:03}.jpg'.format(i)),images_out[i].astype(numpy.uint8))
    imageio.imwrite(os.path.join(output_normal,'{:03}.jpg'.format(i)),images[i].astype(numpy.uint8))

