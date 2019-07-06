function data = readLabels(filename)
%-----READDATASTOREIMAGE Read file formats supported by IMREAD.
%
%  --- See also matlab.io.datastore.ImageDatastore, datastore,mapreduce.
 %-- Turn off warning backtrace before calling imread
onState = warning('off', 'backtrace');
c = onCleanup(@() warning(onState));
data = imread(filename);
data = imresize(data, [224 224]);
data = categorical(255*uint8(im2bw(data)),[255 0],["foreground", "background"]);
