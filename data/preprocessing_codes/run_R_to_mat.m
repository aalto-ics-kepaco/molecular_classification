


function [ ] = run_R_to_mat( inputmatfilename , outputmatfilename)
    
    load(inputmatfilename);
    mat_adj = struct2cell(madj);
    node_labels = struct2cell(n_lab);
    vi = length(node_labels);
    
    N = struct;
    for j = 1:vi
        N(j).nl.values = node_labels{j}; % node labels
        
        N(j).am = mat_adj{j}; % adjacency matrix of the graph
        m = size(N(j).am,1); % number of nodes
        
        [v1,v2,v3]=find(N(j).am);
        N(j).el.values = [v1,v2,v3]; % edge labels
        
        N(j).am = (N(j).am > 0)*1; % adjacency matrix
        
        N(j).al = cell(m,1); % adjacency list
        for k = 1:m
            N(j).al{k} = N(j).el.values(N(j).el.values(:,1) == k,2);
        end
         
    end
    
    save(outputmatfilename,'N');
    exit;

end

