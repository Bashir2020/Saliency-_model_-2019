tic;
clc,close all;
[imagefile, user_canceled] = imgetfile();
if user_canceled
    msgbox(sprintf('No image selected. Try Again!'),'Error','Error');
    return
end
% ------ read test image------
I=imread(imagefile);
figure,
subplot(1,3,1),imshow(I),title('(Test Image)')
% ------ semantic segematation---------
[C,scores] = semanticseg(I,net);
B = labeloverlay(I, C);
L = 2-double(C);
%------------gaussian filter ---------
h = fspecial('gaussian',[],10); 
L2 = imfilter(L,h,'same');
subplot(1,3,2),imshow(B),title('(Human Eye Fixation Prediction)');
subplot(1,3,3),imshow(L2),title('(Human Eye Fixation Prediction)');
toc;
