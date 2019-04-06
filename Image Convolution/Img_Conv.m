clear all;
clc;

Problem_a();
% Problem_b();

function Problem_a()

	test_input = [255, 255, 255;
				  255, 255, 255;
				  255, 255, 255];

	hsize = [[3 3]; [5 5]; [7 7]];
	sig = 1;
	[filter_num, ~] = size(hsize);

	uint_img = imread('cat3_LR.png');
	img = double(uint_img);

	% for idx_hsize = 1:filter_num
	% 	G = fspecial( 'gaussian', hsize(idx_hsize), sig);
	% end

	extended_img = Padding(test_input, hsize(3));
	trimmed_img = Trim(extended_img, hsize(3))
end

function Problem_b()
	a = 1;
end

function extended = Padding(spatial, n)
	[height, width, layer] = size(spatial);
	margin_width = (n - 1)/2;
	extended = zeros(height + margin_width*2, width + margin_width*2, layer);
	for l = 1:layer
		for u = 1:height
			for v = 1:width
				extended(u + margin_width, v + margin_width, l) = spatial(u, v, l);
			end
		end
	end
end

function trimmed = Trim(spatial, n)
	[height, width, layer] = size(spatial);
	margin_width = (n - 1)/2;
	trimmed_height = height - margin_width*2;
	trimmed_width = width - margin_width*2;
	trimmed = zeros(trimmed_height, trimmed_width, layer);

	for l = 1:layer
		for u = 1:trimmed_height
			for v = 1:trimmed_width
				trimmed(u,v,l) = spatial(u + margin_width, v + margin_width, l);
			end
		end
	end
end

function scalar = PSNR(raw_spatial, r_spatial)
	[height, width, layer] = size(raw_spatial);
	MAX_I = 255;
	MSE = 0;

	for l = 1:layer
		for u = 1:height
			for v = 1:width
				MSE = MSE + (raw_spatial(u,v,l) - r_spatial(u,v,l))^2;
			end
		end
	end
	MSE = MSE / (height * width * layer);
	scalar = 10 * log10(MAX_I^2 / MSE);
end