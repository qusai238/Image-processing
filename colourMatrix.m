function finalImage = colourMatrix(filename)
%Function which calls other functions
%reading the Image and converting it to type double, then fixing the image
%for any projections or rotations, also finding the circles
correctedImage=correctImage(filename);%fixing projections and rotations
figure(),imshow(correctedImage)
findCircles(correctedImage);%finding the circles
%Find The Colours of the Squares
colorRecognition=findColours(correctedImage);
finalImage=colorRecognition;
end


