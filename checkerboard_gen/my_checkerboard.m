function I = my_checkerboard(blk_sz, n_row, n_col, margin, unit, save_path)
% generate checkerboard image with assigned size (pixel/inch/mm as unit) for camera calibration
% 
% Param:
% blk_sz:	small square's length, int, default=50
% n_row:	num of rows, int, default=9
% n_col:	num of columns, int, default=6
% margin:	margin around the checkerboard, int, default=10
% unit:		unit of $blk_sz and $margin, string = "pixel" | "mm" | "inch",
%			default = "pixel"
% save_path:save path for the generated checkerboard image (xxx.tiff) , default=[],
%			i.e. don't save. Supporting format is tiff. 
% 
% Example:
% I = my_checkerboard(1, 6, 9, 1, 'inch','./checkerboard.tiff')
% 
% Note:
% The code will save the checkerboard image with given physical size ($unit="mm"|"inch") by setting
% corresponding dpi. If not assign physical size ($unit=pixel) , the image
% will be saved with default dpi=300. Note that, in order to print the
% image with given physical size, choose scale=100%£¬ i.e. no scale or original size
% in print setting. Windows buildin program "mspaint" is recommended for print the
% image.
% 
% Auhtor: Zhihong Zhang, 2022-03-08
% 


% param assign
if nargin<6
	save_path = [];	% save path, xxx.tiff
	if nargin<5
		unit = "pixel"; % unit: pixel | mm | inch
		if nargin<4
			margin = 10;  % margin of the checkerboard
			if nargin<3
				blk_sz = 50;  % length of the square
				if nargin<2
					n_row =9;     % number of row
					if nargin<1
						n_col = 6;    % number of col
					end
				end
			end
		end
	end
end

% unit convert
if strcmp(unit,"pixel")
	dpi = 300;
	scale = 1;
elseif strcmp(unit,"mm")
	dpi = 254;
	scale = 10;
elseif strcmp(unit,"inch")
	dpi = 300;
	scale = 300;
end
	

% checkerboard generation
I = ones(n_row*blk_sz+2*margin,n_col*blk_sz+2*margin)*255;
for i = 1:n_row
	if mod(i,2)==1
		for j = 1:n_col
			if mod(j,2)==1
			I(1+(i-1)*blk_sz+margin:i*blk_sz+margin,...
			1+(j-1)*blk_sz+margin:j*blk_sz+margin) = 0;
			end
		end
	else
		for j = 1:n_col
			if mod(j,2)==0
			I(1+(i-1)*blk_sz+margin:i*blk_sz+margin,...
			1+(j-1)*blk_sz+margin:j*blk_sz+margin) = 0;
			end
		end
	end
end

% dpi adaptation
I = kron(I,ones(scale));


% show
imshow(I);


% save to image
if save_path
	imwrite(I, save_path, 'tiff', 'Resolution', dpi)
end
	
	
end
