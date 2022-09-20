function [centers,radii] = findCircles(image)
[Centers,radii]=  imfindcircles(image,[20 25],'ObjectPolarity','dark','Sensitivity',0.92,'Method','twostage'); %Detect and find the Circles with their centers and Radii.
circle= viscircles(Centers,radii) %Draw the Cricles boundaries on the image.
centers=[Centers] %centers of the circles
radii=[radii];%raddii of the circles
end



