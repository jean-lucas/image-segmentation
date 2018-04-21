%%%%
%   Required MATLAB 2018a with:
%       Image Processing Toolbox
%       Neural Network Toolbox
%%%
function main(img)



    LABELS_PATH         = './labels_modelA.txt'; 
    KERAS_MODEL_PATH    = './modelA.h5'; %CNN model created by keras
    TEST_IMG            = img;
    SIZE_W              = 32;
    SIZE_H              = 32;

    %get the keras network model and labels
    [network, labels] = model_loader(KERAS_MODEL_PATH, LABELS_PATH);
    
    
    %segment the given image and create nesting graph
    [graph, filenames] = segment_img(TEST_IMG, SIZE_H, SIZE_W);
    figure; 
    plot(graph);   
     
            
    %traverse the graph to generate logical ordering of symbols
    values = {};
    values = traverse(graph,1,values);
    fid = fopen('output.txt','w');
    

    %classify each symbol
    for i = 1:length(values)
        if isnumeric(values{i})
           
            file = strcat('out/', filenames(values{i}-1));
            file = char(file);
            img  = imread(file, 'png');
            img  = im2uint8(img);
            l    = classify(network, img);
            fprintf('%s ', labels(l).symbol);
            fprintf(fid,'%s',labels(l).symbol);
          
        else
            fprintf('%s', values{i});
            fprintf(fid,'%s',values{i});
        end
           
    end

    fprintf('\n\n');
    
    
    
    fclose(fid);
end




%traverse the graph and organize the nodes such that we get the correct
%nesting of square root operations.
function values = traverse(graph, node, vals)
    v = successors(graph, node);
    values = vals;
    if ~isempty(v)
        if node ~= 1 % 1 is the root
            values{end+1} = '\sqrt';
            values{end+1} = '{';
        end
 
        for i = 1:size(v,1)
           values = traverse(graph,v(i), values);
        end
        disp(node);
        if node ~= 1
            values{end+1} = '}';
        end

    else
        values{end+1} = node;
    end
    
end




