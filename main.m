function main()

    LABELS_PATH        = '~/keras-workspace/labels.txt';
    KERAS_MODEL_PATH   = '~/keras-workspace/my_model.h5';
    TEST_IMG           = 'images/test8.png';
    SIZE_W             = 32;
    SIZE_H             = 32;

    %get the keras network model and labels
    [network, labels] = model_loader(KERAS_MODEL_PATH, LABELS_PATH);
    
    
    %segment the given image and create nesting graph
    [graph, filenames] = segment_img(TEST_IMG, SIZE_H, SIZE_W);
    %plot(graph);
    
    %traverse the graph to generate logical ordering of symbols
    values = {};
    values = traverse(graph,1,values);

    %classify each symbol
    for i = 1:length(values)
        if isnumeric(values{i})
           
            file = strcat('out/', filenames(values{i}-1));
            file = char(file);
            img  = imread(file, 'png');
            img  = im2uint8(img);
            l   = classify(network, img);
            fprintf('%s', labels(l).symbol);
          
        else
            fprintf('%s', values{i});
        end
           
    end

    fprintf('\n\n');
    

end




%traverse the graph and organize the nodes such that we get the correct
%nesting of square root operations.
function values = traverse(graph, node, vals)
    v = successors(graph, node);
    values = vals;
    if ~isempty(v)
        if node ~= 1
            values{end+1} = 'sqrt';
            values{end+1} = '(';
        end
 
        for i = 1:size(v,1)
           values = traverse(graph,v(i), values);
        end
        if node ~= 1
            values{end+1} = ')';
        end

    else
        values{end+1} = node;
    end
    
end



