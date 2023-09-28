% param setting
sub_mask_size = [256 256];  % mask block size
stitching_shape = [1 1];	% block stitching shape
pixel_size = 4.5; % um		% mask's pixel size
upsampling_scale = 3;		% mask matrix upsampling scale ( 3 is recommended, generally, no need to change)
save_name = ['Mask' num2str(sub_mask_size(1)) '_Rep' num2str(stitching_shape(1)) '_PixelSize' num2str(pixel_size)...
	'_Kron' num2str(upsampling_scale) '.tif'];


dpi = 25400/pixel_size;  % dots per inch

% mask generation
sub_mask = double(binary_mask(sub_mask_size));
sub_mask = kron(sub_mask, ones(upsampling_scale));

if all(stitching_shape==1)
	mask = sub_mask;
else
	mask = repmat(sub_mask, stitching_shape);
end

% mask save
imwrite(mask, save_name, 'tiff', 'Resolution', dpi*upsampling_scale)

% auxiliary function
function mask = binary_mask(sz, mode, param)
%BINARY_MASK	generate a binary mask with given size and other info.
% 
%The binary mask can be generated in a random or determined way.
%It can also generate a binary mask from given image.
% 
%   Input:
%   --------
%   - size: mask size, scalar or int 2D-vector
% 
%   - mode: mask's generating method, str, {'rand', 'fixed', 'image'},
%   optional, default='rand'
% 
%   - param:
%           - for 'rand' mode: 'param' is the "1"'s probability, i.e. the
%           transmittance, float, optional, default=0.5. The mask is
%           generated from RAND (uniform random distribution).
% 
%           - for 'fixed' mode: 'param' is the pattern type, str,
%           {'up_half', 'down_half'}
% 
%           - for 'image' mode: 'param' is an image, it will be resized to 
%           given size and then converted to a binary matrix with 'im2bw'
%           
%   Output:
%   --------
%   - mask: binary mask, logical 2D matrix,{0, 1}
% 
%   See also:
%   --------
%   RAND, IMBINARIZE
% 
%   Log:
%   --------
% 
%   Info:
%   --------
%   Created:        Zhihong Zhang <z_zhi_hong@163.com>, 2020-03-22
%   Last Modified:  Zhihong Zhang, 2020-03-22
%               
%   Copyright 2020 Zhihong Zhang

% input setting
narginchk(1,3);
if nargin == 1
    mode = 'rand';
    param = 0.5;
elseif nargin == 2 
    if isa(mode, 'float')|| isa(mode, 'double')
        param = mode;
        mode = 'rand';
    else
        error('input error!');
    end
end

if isscalar(sz)
    sz = [sz sz];
end
    
% mask generating
switch mode
    case 'rand'
        if (0<=param) && (param<=1)
            mask = rand(sz);
            tmp = mask;            
            mask(tmp>param) = false;
            mask(tmp<=param) = true;
        else
            error('the input probability should be in [0 1]')
        end
    case 'fixed'
        if strcmp(param, 'up_half')
            mask = zeros(sz);
            mask(1:ceil(sz(1)/2),:) = true;
        elseif strcmp(param, 'down_half')
            mask = zeros(sz);
            mask(floor(sz(1)/2):end,:) = true;
        else
            error('unsupported mask type -  "%s"', param);
        end
    case 'image'
        if isnumeric(param) && ismatrix(param)
            img = im2double(imresize(param, sz));
        	mask = imbinarize(img); 
        elseif  isnumeric(param) && (ndims(param)==3 && size(param,3)==3)
            img = im2double(imresize(rgb2gray(param), sz));
            mask = imbinarize(img);
        else
            error('error arguement for - "%s"', mode);
        end
end
mask = logical(mask);
end
