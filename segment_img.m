function [graph, filenames] = segment_img(img_in, h_out, w_out)
%SEGMENT_IMG Segments an image into different components.
%   Creates a minimal bounding box around each component of the given 
%   image, crops each bounding box from the original image and saves it 
%   to a new file. The function returns the filename for each image 
%   that was saved.
%
%   Some components were taken from:
%   https://www.mathworks.com/help/images/examples/correcting-nonuniform-illumination.html.
%
%   Args:
%       img_in (string): name of image to apply
%       w_out (int)    :  width of output pictures 
%       h_out (int)    :  height of output pictures
%   
%   Return:
%       Array of strings corresponding to their filename (with extension)
%
%   Example: 
%       segment_img('test.png', 64,128)
%    -> ['char_1.png', 'char_2.png', 'char_3.png']



    %read img and convert to grayscale
    color_img = imread(img_in);
    i = rgb2gray(color_img);

    %complement (since white paper and black text)
    icomp = imcomplement(i);

    %subtracts image from a top-hat morphological opening
    i2 = imtophat(icomp,strel('disk',15));

    %contrast
    i3 = imadjust(i2);
    size(i3)

    %threshold (binarize img)
    %Remove small objects from binary image
    bw = imbinarize(i3);
    bw = bwareaopen(bw,100); 



    %find all connected components
    %cc_val is the desired connectivity 
    cc_val = 4; % can be 4 or 8
    cc = bwconncomp(bw,cc_val);


    % see: https://www.mathworks.com/help/images/ref/regionprops.html#inputarg_properties
    % for  different regionProps parameter options, such as 'Centroids'.
    BB = regionprops(cc, 'BoundingBox');
    num_boxes = length(BB);
    
   %plot(nesting_graph(BB), 'LineWidth',3);
    graph = nesting_graph(BB);


    filenames = strings(1, num_boxes);
    out_dir = 'out/';
         
    %crop, pad, invert and save each bounding box
    for rect = 1:num_boxes
        
        %draw bounding boxes
        %i3 = insertShape(i3, 'Rectangle', BB(rect).BoundingBox, 'Color', 'yellow','LineWidth',2);
        
        
        crop = imcrop(bw, BB(rect).BoundingBox);
        crop = imcomplement(crop); %make background white, text black
        
        [ih, iw] = size(crop);
       
        %scale images appropriately 
        
        if ih < h_out && iw < w_out
            pad = [ floor((h_out-ih)/2)  floor((w_out-iw)/2)];
            crop = padarray(crop, pad, 1, 'both');
     
        elseif ih >= h_out && iw < w_out 
            crop = imresize(crop, h_out/ih);
            [~, w] = size(crop);
            pad = [ 0  floor((w_out-w)/2)];
            crop = padarray(crop, pad, 1, 'both');
    
        elseif ih < h_out && iw >= w_out 
            crop = imresize(crop, w_out/iw);
            [h, ~] = size(crop);
            pad = [ floor((h_out-h)/2) 0];
            crop = padarray(crop, pad, 1, 'both');
        end

        crop = imresize(crop, [h_out w_out]);

        filename = sprintf('char_%d.png', rect);
        filenames(rect) = filename;
        imwrite(crop, strcat(out_dir,filename));

    end

end


