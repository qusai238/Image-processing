function correctedImage= correctImage(filenmae)
%function that fix the Projections/Rotations
orgImage=LoadImage(filenmae);
BandWimage=~im2bw(orgImage,0.5);%converting the image to black and white
BandWfill=imfill(BandWimage,'holes');%filling any holes in the image
medianFilt=medfilt2(BandWfill);%filtering using a median filter
connectedComps=bwconncomp(medianFilt);%finding the connceted components in the image
stats=regionprops(medianFilt,'Area','Centroid');%getting stats of the image(area,centroid)
Areas=[stats.Area];
Circles=zeros(connectedComps.ImageSize);%Isolating the circles 
for p = 1:connectedComps.NumObjects 
    if stats(p).Area<max(Areas)
        Circles(connectedComps.PixelIdxList{p}) = 1; 
    end
end
%figure,imshow(Circles,[0,1]), title("Input's Image Isolated Circles")
circlesLabeled=bwlabel(Circles, 8);%returning the label matrix L for 8 connceted objects (labeling the circles).
circlesProps=regionprops(circlesLabeled,'Area','Centroid');%Stats of the circles
circlesCentroids=[circlesProps.Centroid];%centroids of the circles
varyingPoints=reshape(circlesCentroids,2,[]);%seting centroids of the image as reference points for transformation.
MovingPointsT=transpose(varyingPoints);%transposing the matrix to get it in the correct form 
staticPoints=flip(findCircles(LoadImage('org_1.png')));%Setting the fixed points as centroids of org_1.png
transformation=fitgeotrans(MovingPointsT,staticPoints,'Projective');%applying the transformation 
Reference=imref2d(size(LoadImage('org_1.png')));%referencing the size of org_1.png
correctedImage=imwarp(orgImage,transformation,'OutputView',Reference);%determining pixel values for output image by mapping locations of the output to the input image
end

