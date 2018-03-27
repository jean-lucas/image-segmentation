function [G] = nesting_graph(bboxes)
%NESTING_GRAPH is a tree-like representation of the given mathemeticak
% expression. This gives a better intitution on how we should parse, or 
% organize each symbol.
%

    G = digraph();
    root = 1;
    num_boxes = length(bboxes);
    
    f = zeros(num_boxes);
    
    for i = 1:num_boxes
        x = get_all_children(i, bboxes);
        f(i,:) = x;
        
    end
        
    %keeps track of nodes who already have the correct parents
    %and can be ignored
    hasCorrectParent = zeros(1,num_boxes+1);
    
    %go through each node and see if it has children
    for i = num_boxes:-1:1

        parent = i+1;
        
        %no children
        if sum(f(i,:)) == 0
            G = addedge(G,root, parent);
        
        %at least one child
        else
            
            %connect this parent to the main root
            G = addedge(G, root,parent);
            
            %for each child
            for j = 1:length(f(i,:))
                
                if f(i,j) ~= 0
                    child = f(i,j) + 1;
                    %check if node has been already added to the root
                    %if so, connect it to the parent instead
                    if findedge(G,root,child) ~= 0
                        G = rmedge(G,root, child);
                    end
                      
                    if ~ismember([child],hasCorrectParent)
                        G = addedge(G,parent,child);
                        hasCorrectParent(i+1) = child;
                    end
                end
            end
        end
    end
end




%for a given node, return all bounding boxes that nest it
function [arr] = get_all_children(currNode, boxes)
   
    root = boxes(currNode);
    
    rx = root.BoundingBox(1);
    ry = root.BoundingBox(2);
    rw = root.BoundingBox(3);
    rh = root.BoundingBox(4);
    
    num_boxes = length(boxes);
    arr = zeros(1,num_boxes);
    pos = 1;
    for i = currNode+1:num_boxes
        x = boxes(i).BoundingBox(1);
        y = boxes(i).BoundingBox(2);
        w = boxes(i).BoundingBox(3);
        h = boxes(i).BoundingBox(4);
        
        if (x > rx && y > ry) && (x+w < rx+rw && y+h < ry+rh)
            arr(pos)=i;
            pos = pos +1;
        end
       
    end
    
    
end




