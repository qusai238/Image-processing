function [ image] = LoadImage( filename )
%function to load the image and convert it to type double
image=imread(filename); %read the image file
if isa(image,'uint8')%check if the image is type unit8
    image=double(image)/255; %change the image type to double
else
    error('The image is of unknown type');%return error message if image is not type unit8
end
end
