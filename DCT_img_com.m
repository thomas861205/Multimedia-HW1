clear all;
clc;

RGB_img = double(imread('cat1.png'));
% image(RGB_img)
% [height, width, ~] = size(RGB_img)
YIQ_img = RGB2YIQ(RGB_img);
% YIQ_testbench = rgb2ntsc(RGB_img);


function YIQ_img = RGB2YIQ(RGB_img)
	[height, width, ~] = size(RGB_img);
	YIQ_img = zeros(height, width, 3);
	RGB2YIQmat = [
		0.299, 0.587,  0.114;
		0.596, -0.275, -0.321;
		0.212, -0.523, 0.311];
	for h = 1:height
		for w = 1:width
			YIQ_img(h, w, :) = RGB2YIQmat * reshape(RGB_img(h, w, :),[],1);
		end
	end
end