function B = imbinNiblack(I,w)

% IMBINNIBLACK Implements Niblack's local thresholding algorithm for
% binarizing the input image
%
% B = imbinNiblack(I,w) computes the binary image B from the input image I
% using Niblack's algorithm as described in Senthilkumaran et al "Efficient
% implementation of Niblack Thresholding for MRI brain image segmentation"
% IJCIT, 5(2), 2014, 2173-2176. The neighbourhood size is w
%
% B = imbinNiblack(I,w) computes the binary image B from the input image I
% using Niblack's algorithm with a neighbourhood size of w = 5
%
% @ 2021, Infor, AOCG-UCM

% Set the default neighbourhood size
if(nargin<1||nargin<2)
    error('The function should only have 1 or 2 input parameters')
elseif(nargin==1)
    w = 5;
end

% Checks whether the input image is rgb
if(numel(size(I))==3)
    I = rgb2gray(I);
end
I = im2double(I); % Convert to double precision

% Preprocessing: Local Histogram Equalization
I = adapthisteq(I);

% Computes mean and standard deviation
M = imfilter(I,ones(w)/w/w,'replicate','same');
fun = @(x) std(x(:));
S = nlfilter(I,[w w],fun);

% Determine the local threshold
T = M - 0.2*S;

% Image binarization
B = I>T;