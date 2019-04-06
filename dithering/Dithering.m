clear all;
clc;

% Problem_a();
% Problem_b();
Problem_c();

function Problem_a()
	img = imread('cat2_gray.png');
	dithered = Noise_Dithering(img);
	imwrite(dithered, sprintf('noise_dithered.png'));
	% imshow(dithered);
end

function Problem_b()
	img = imread('cat2_gray.png');
	dithered = Average_Dithering(img);
	imwrite(dithered, sprintf('average_dithered.png'));
	% imshow(dithered);
end

function Problem_c()
	img = imread('cat2_gray.png');
	dithered = Error_Diffusion_Dithernig(img);
	imwrite(dithered, sprintf('error_diffusion_dithered.png'));
	% imshow(dithered);
end

function dithered = Noise_Dithering(spatial)
	[height, width] = size(spatial);
	thres = randi([0, 255], height, width);
	dithered = zeros(height, width);

	for u = 1:height
		for v = 1:width
			if spatial(u,v) > thres(u,v)
				dithered(u,v) = 255;
			end
		end
	end
end

function dithered = Average_Dithering(spatial)
	[height, width] = size(spatial);
	avg = 0;
	pixel_num = 0;

	for u = 1:height
		for v = 1:width
			pixel_num = pixel_num + 1;
			avg = avg + 1/pixel_num * (double(spatial(u, v)) - avg);
		end
	end

	thres = avg * ones(height, width);
	dithered = zeros(height, width);
	for u = 1:height
		for v = 1:width
			if spatial(u,v) > thres(u,v)
				dithered(u,v) = 255;
			end
		end
	end
end

function dithered = Error_Diffusion_Dithernig(spatial)
	[height, width] = size(spatial);
	dithered = double(spatial);

	for u = 1:height
		for v = 1:width
			if spatial(u,v) < 128
				err = spatial(u,v);
			else
				err = spatial(u,v) - 255;
			end

			if v+1 <= width
				dithered(u,v+1)   = dithered(u,v+1)   + (7/16)*err;
			end
			if u+1 <= height && v-1 >= 1
				dithered(u+1,v-1) = dithered(u+1,v-1) + (3/16)*err;
			end
			if u+1 <= height
				dithered(u+1,v)   = dithered(u+1,v)   + (5/16)*err;
			end
			if u+1 <= height && v+1 <= width
				dithered(u+1,v+1) = dithered(u+1,v+1) + (1/16)*err;
			end
		end
	end

	for u = 1:height
		for v = 1:width
			if dithered(u,v) < 128
				dithered(u,v) = 0;
			else
				dithered(u,v) = 255;
			end
		end
	end
end