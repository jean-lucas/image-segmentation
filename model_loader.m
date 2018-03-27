function [network, labels] = model_loader(model_path, labels_path)
%MODEL_LOADER will import the pre-trained Keras network, and
% create a data structure of labels that are defined in the keras network.
%
% labels: {id: 123, symbol: +}, {id:456, symbol: x} ...
%
    
    network = importKerasNetwork(model_path);
    label_file = fopen(labels_path, 'r');
    line = fgetl(label_file);
    
    labels = struct;
    i = 1;
    while ischar(line)
       l = strsplit(line,', ');
       labels(i).id = l{1};
       labels(i).symbol = l{2};
       line = fgetl(label_file);
       i = i+1;
    end
    
    fclose(label_file);

end

