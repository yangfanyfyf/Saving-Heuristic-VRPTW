function [routes, routes_weight] = CWHeuristic(dists, saving_array,capacity, demand)
    num_nodes = size(demand,1);
    routes = zeros(num_nodes - 1, num_nodes - 1);
    routes_weight = zeros(num_nodes - 1, 1);
    rows = size(saving_array, 1);
    for i = 1 : rows
        point1 = saving_array(i,1);
        point2 = saving_array(i,2);
        appears = zeros(2,2);
        % InRoute
        appears(1,:) = InRoute(point1, routes);
        appears(2,:) = InRoute(point2, routes);
    
        if sum(appears(:,1)) == 0
            curr_weight = sum(demand(point1,2), demand(point2,2));
            if curr_weight <= capacity
                new_route_id = 0;
                for j = 1 : size(routes, 1)
                    if routes(j,1) == 0
                        new_route_id = j;
                        break;
                    end
                end
                routes(new_route_id, 1:2) = [point1, point2];
                routes_weight(new_route_id) = curr_weight;
            end
        else
            if sum(appears(:,1)) == 1
                routes
                appears
                i
                [~, idx] = sortrows(appears, -1);
                repeat_point_id = idx(1);
                repeat_mode = appears(repeat_point_id, 1);
                obj_row = appears(repeat_point_id, 2)
                pp = appears(idx(2), 1)
                curr_sum_weight = demand(pp, 2) + routes_weight(obj_row);
                if curr_sum_weight <= capacity
                    if repeat_mode == 1
                        mid_route = routes(obj_row, :);
                        mid_route = circshift(mid_route, 1);
                        mid_route(1) = pp;
                        routes(obj_row, :) = mid_route;
                    else
                        mid_route = routes(obj_row, :);
                        zero_id = 0;
                        for k = 1 : size(mid_route, 2)
                            if mid_route(k) == 0
                                zero_id = k;
                                break;
                            end
                        end
                        mid_route(zero_id) = pp;
                        routes(obj_row, :) = mid_route;
                    end
                end
            else
            end
        end
    end

                        

end