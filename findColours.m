function colours=findColours(image)
%function to find the colours of the squares 
image = imerode(image,ones(5));%erroding the image
image = medfilt3(image,[11 11 1]); % median filter to suppress noise
image = imadjust(image,stretchlim(image,0.05)); % increase contrast of the image
figure(),imshow(image)
imageMask= rgb2gray(image)>0.08; %converting the image into greyscale 
imageMask = bwareaopen(imageMask,100); % removing positive specks
imageMask = ~bwareaopen(~imageMask,100); % removing negative specks
imageMask = imclearborder(imageMask); % removing outer white region
imageMask = imerode(imageMask,ones(10)); % eroding to exclude edge effects
% segmenting the image
[L N] = bwlabel(imageMask);
% getting average color in each image mask region
maskColors = zeros(N,3);
for p = 1:N % stepping throughout the patches
    imgmask = L==p;
    mask= image(imgmask(:,:,[1 1 1]));
    maskColors(p,:) = mean(reshape(mask,[],3),1);
end
% trying to snap the centers to a grid
Stats = regionprops(imageMask,'centroid'); %obtaining the centroids
Centroids = vertcat(Stats.Centroid);%concatenatoin 
centroidlimits = [min(Centroids,[],1); max(Centroids,[],1)];
Centroids= round((Centroids-centroidlimits(1,:))./range(centroidlimits,1)*3 + 1);
% reordering colour samples
index = sub2ind([4 4],Centroids(:,2),Centroids(:,1));
maskColors(index,:) = maskColors;
% specify colour names and their references 
colorNames = {'white','red','green','blue','yellow'};
colorReferences = [1 1 1; 1 0 0; 0 1 0; 0 0 1; 1 1 0];
% finding color distances in RGB
distance = maskColors - permute(colorReferences,[3 2 1]);
distance = squeeze(sum(distance.^2,2));
% finding index of closest match for each patch
[~,index] = min(distance,[],2);
% looking up colour names and returning a matrix of colour names
colours = reshape(colorNames(index),4,4)
end