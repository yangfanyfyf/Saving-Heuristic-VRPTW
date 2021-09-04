function [routes, routes_weight] = CWHeuristic(dist, saving_array)
    num_nodes = size(dist,1);
    routes = zeros(num_nodes - 1, num_nodes - 1);
    routes_weight = zeros(num_nodes - 1, 1);
    rows = size(saving_array, 1);
    for i = 1 : rows
        point1 = saving_array(i,1);
        point2 = saving_array(i,2);
        appears = zeros(2,2)
        % InRoute
        
    end



end