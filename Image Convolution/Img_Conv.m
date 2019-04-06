clear all;
clc;

Problem_a();
Problem_b();

function Problem_a()
	hsize = [[3 3]; [5 5]; [7 7]];
	sig = 1;
	[filter_num, ~] = size(hsize);
	PSNRs = zeros(1, filter_num);
	uint_img = imread('cat3_LR.png');
	img = double(uint_img);

	for idx_hsize = 1:filter_num
		G = fspecial( 'gaussian', hsize(idx_hsize), sig);
		extended_img = Padding(img, hsize(idx_hsize));
		convolved = Convolution(extended_img, G);
		trimmed_img = Trim(convolved, hsize(idx_hsize));
		% imshow(uint8(trimmed_img))
		imwrite(uint8(trimmed_img), sprintf('a_n%d_conv.png', hsize(idx_hsize)));
		PSNRs(idx_hsize) = PSNR(img, trimmed_img);
	end
	save('PSNR_a.mat', 'PSNRs');
end

function Problem_b()
	hsize = [5 5];
	sig = [1, 5, 10];
	PSNRs = zeros(1, length(sig));
	uint_img = imread('cat3_LR.png');
	img = double(uint_img);

	for idx_sig = 1:length(sig)
		G = fspecial( 'gaussian', hsize, sig(idx_sig));
		extended_img = Padding(img, 5);
		convolved = Convolution(extended_img, G);
		trimmed_img = Trim(convolved, 5);
		% imshow(uint8(trimmed_img))
		imwrite(uint8(trimmed_img), sprintf('b_sig%d_conv.png', sig(idx_sig)));
		PSNRs(idx_sig) = PSNR(img, trimmed_img);
	end
	save('PSNR_b.mat', 'PSNRs');
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

function convolved = Convolution(spatial, G)
	[height, width, layer] = size(spatial);
	[G_height, G_width] = size(G);
	margin_height = (G_height-1)/2;
	margin_width = (G_width-1)/2;
	offset_height = (margin_height+1);
	offset_width = (margin_width+1);
	convolved = zeros(height, width, layer);

	for l = 1:layer
		for u = 1+margin_height : height-margin_height
			for v = 1+margin_width : width-margin_width
				tmp = 0;
				for r =  1:G_height
					for s = 1:G_width
						tmp = tmp + spatial(u+r-offset_height, v+s-offset_width, l) * G(r,s);
					end
				end
				convolved(u, v, l) = tmp;
			end
		end
	end
	disp('Done Convolution')
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