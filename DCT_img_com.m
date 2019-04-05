clear all;
clc;

% input = [0, 0, 0, 153, 255, 255, 220, 220]';
% output = OneD_DCT(input)

% input = [255, 255, 255, 255, 255, 255, 159, 159;
% 		 255,   0,   0,   0, 255, 255, 159, 159;
% 		 255,   0,   0,   0, 255, 255, 255, 255;
% 		 255,   0,   0,   0, 255, 255, 255, 255;
% 		 255, 255, 255, 255, 255, 255, 100, 255;
% 		 255, 255, 255, 255, 255, 255, 100, 255;
% 		 255, 255, 255, 255, 255, 255, 100, 255;
% 		 255, 255, 255, 255, 255, 255, 100, 255];
% r_input = Divide_and_Drop(input, 4);
% image(uint8(r_input),'CDataMapping','scaled');


Problem_a();

function Problem_a()
	images = ["cat1.png", "cat2_gray.png", "cat3_LR.png"];
	n = [2, 4, 8];

	for img = 1:length(images)
		for nn = 1:length(n)
			filename = char(images(img));
			RGB_img = double(imread( filename ));
			RGB_img = Padding(RGB_img);
			r_RGB_img = Divide_and_Drop(RGB_img, nn);
			imwrite(uint8(r_RGB_img), sprintf('n%d_%s', n(nn), filename));
		end
	end
end

function Problem_b()
	% YIQ_img = RGB2YIQ(RGB_img);
	% YIQ_testbench = rgb2ntsc(RGB_img);
end

function extended = Padding(spatial)
	[height, width, layer] = size(spatial);
	n = 8;
	if mod(height, n) == 0 && mod(width, n) == 0
		extended = spatial;
	else
		ext_height = (uint64((height - 1)/n) + 1) * n;
		ext_width = (uint64((width - 1)/n) + 1) * n;
		extended = zeros(ext_height, ext_width, layer);
		for u = 1:height
			for v = 1:width
				extended(u, v, :) = spatial(u, v, :);
			end
		end
	end
end


function r_spatial = Divide_and_Drop(spatial, n)
	[height, width, layer] = size(spatial);
	frequency = zeros(height, width, layer);
	tmp = zeros(8, 8, layer);

	for uu = 1:8:height
		for vv = 1:8:width
			tmp = TwoD_DCT(spatial(uu:uu+8-1, vv:vv+8-1, :));
			tmp = Drop(tmp, n);
			r_spatial(uu:uu+8-1, vv:vv+8-1, :) = TwoD_invDCT(tmp);
			% for l = 1:layer
			% 	tmp = TwoD_DCT(spatial(uu:uu+8-1, vv:vv+8-1, l));
			% 	tmp = Drop(tmp, 8);
			% 	r_spatial(uu:uu+8-1, vv:vv+8-1, l) = TwoD_invDCT(tmp);
			% end
		end
	end
	disp('Done Divide_and_Drop')
end

function dropped = Drop(frequency, n)
	[height, width, layer] = size(frequency);
	dropped = zeros(height, width, layer);
	for l = 1:layer
		for u = 1:n
			for v = 1:n
				dropped(u, v, l) = frequency(u, v, l);
			end
		end
	end
	disp('Done Drop')
end

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
    disp('Done OneD_DCT')
end

function frequency = TwoD_DCT(spatial)
	[height, width, layer] = size(spatial);
	frequency = zeros(height, width, layer);
	for l = 1:layer
		for u = 0:height-1
			for v = 0:width-1
				tmp = 0;
				for r = 0:height-1
					for s = 0:width-1
						tmp = tmp + 2/sqrt(height*width)*C(u)*C(v) * spatial(r+1,s+1,l) *...
						 cos((2*r+1)*u*pi/(2*height))*cos((2*s+1)*v*pi/(2*width));
					end
				end
				frequency(u+1, v+1, l) = tmp;
				% fprintf('TwoD_DCT: done F(%d,%d).\n', u+1, v+1);
			end
		end
		fprintf('TwoD_DCT: done layer %d.\n', l);
	end
	disp('Done TwoD_DCT')
end

function spatial = TwoD_invDCT(frequency)
	[height, width, layer] = size(frequency);
	spatial = zeros(height, width, layer);
	for l = 1:layer
		for r = 0:height-1
			for s = 0:width-1
				tmp = 0;
				for u = 0:height-1
					for v = 0:width-1
						tmp = tmp + 2/sqrt(height*width)*C(u)*C(v) * frequency(u+1,v+1,l) *...
						 cos((2*r+1)*u*pi/(2*height))*cos((2*s+1)*v*pi/(2*width));
					end
				end
				spatial(r+1, s+1, l) = tmp;
			end
		end
	end
	disp('Done TwoD_invDCT')
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
	disp('Done RGB2YIQ')
end