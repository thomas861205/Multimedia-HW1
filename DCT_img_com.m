clear all;
clc;

RGB_img = double(imread('cat1.png'));
% image(RGB_img)
% [height, width, ~] = size(RGB_img)
YIQ_img = RGB2YIQ(RGB_img);
% YIQ_testbench = rgb2ntsc(RGB_img);


% input = [0, 0, 0, 153, 255, 255, 220, 220]';
% output = OneD_DCT(input)

input = [255, 255, 255, 255, 255, 255, 159, 159;
		 255,   0,   0,   0, 255, 255, 159, 159;
		 255,   0,   0,   0, 255, 255, 255, 255;
		 255,   0,   0,   0, 255, 255, 255, 255;
		 255, 255, 255, 255, 255, 255, 100, 255;
		 255, 255, 255, 255, 255, 255, 100, 255;
		 255, 255, 255, 255, 255, 255, 100, 255;
		 255, 255, 255, 255, 255, 255, 100, 255];
output = TwoD_DCT(input)

function ret = C(u)
	if u == 0
		ret = sqrt(2)/2;
	else
		ret = 1;
	end
end

function frequency = OneD_DCT(spatial)
	[height, width] = size(spatial);
    frequency = zeros(height, width);
    for u = 0:height-1
    	tmp = 0;
    	for r = 0:height-1
    		tmp = tmp + sqrt(2/height)*C(u) * spatial(r+1) * cos((2*r+1)*u*pi/(2*height));
    	end
    	frequency(u+1) = tmp;
    end
end

function frequency = TwoD_DCT(spatial)
	[height, width, layer] = size(spatial)
	frequency = zeros(height, width, layer);
	for l = 1:layer
		for u = 0:height-1
			for v = 0:width-1
				tmp = 0;
				for r = height-1
					for s = width-1
						tmp = tmp + 2/sqrt(height*width)*C(u)*C(v) * spatial(r,s,l) *...
						 cos((2*r+1)*u*pi/(2*height))*cos((2*s+1)*v*pi/(2*width));
					end
				end
				frequency(u+1, v+1, l) = tmp;
			end
		end
	end
end

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