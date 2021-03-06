function route = SavingHeuristic(dists, saving_matrix, time_window1, time_window2, depot_time_window2, service_time, destination)
    %parallel saving algorithm
    [row,~] = max(size(dists));
    if row > 2
        % point 1 is depot 
        customer_qty = size(dists,1) - 1; 
        % build an empty route 
        route = zeros(customer_qty, customer_qty+2); 
        
        finish_node_qty = 0;
        set_route_qty = 0;
        % visited nodes
        finish_nodes = zeros(1, customer_qty);
        %finishNodes(1) = 1;
        % size of saving array 
        save_rows=size(saving_matrix,1);
        % 
        for i= 1 : save_rows
            % 2 nodes in a line 
            nodeA = saving_matrix(i,1)-1;
            nodeB = saving_matrix(i,2)-1;
            if destination(nodeA) == -2 && destination(nodeB) == -2
                continue;
            end
            % nodes in route?
            [rowA,colA] = find(route==nodeA);
            [rowB,colB] = find(route==nodeB);
            find_A = sum(rowA)+sum(colA);
            find_B = sum(rowB)+sum(colB);
            % no
            % Situation 1
            if find_A + find_B == 0
                % find an empty route
                midIdx = find(route(:,1) == 0);
                midIdx2 = sum(midIdx);
                if midIdx2 > 0 
                    thisRow = midIdx(1);
                    %%%%
                    temp_route = route(thisRow, :);
                    if time_window1(nodeA) <= time_window1(nodeB)
                        temp_route(1,1) = nodeA;
                        temp_route(1,2) = nodeB;
                        
                    else
                        temp_route(1,1) = nodeB;
                        temp_route(1,2) = nodeA;
                        
                    end
                    flag = JudgeRoute(temp_route,time_window1, time_window2, depot_time_window2, service_time,dists);
                    % capacity not violated
                    if flag == 1
                        %route(thisRow,1) = 0; % depot
                        route(thisRow,:) = temp_route;
                        % visted nodes + 2
                        finish_node_qty = finish_node_qty + 2;
                        % used routes
                        set_route_qty = set_route_qty + 1;
                        % 2 nodes has been visted
                        finish_nodes(nodeA) = finish_nodes(nodeA) + 1;
                        finish_nodes(nodeB) = finish_nodes(nodeB) + 1;
                    end
                else
                    disp('error 1');
                end
            % points are already in routes
            elseif find_A + find_B > 0
                % Situation 2
                % only one point in a route
                if find_A * find_B == 0
                    if find_A > 0
                        % target and position of insertion
                        newNode = nodeB;
                        addRow = rowA(1); 
                        addCol = colA(1);
                    else
                        newNode = nodeA;
                        addRow = rowB(1); 
                        addCol = colB(1);
                    end
                    
                    midRouteLength = max(find(route(addRow,:)>1));
                    % insert
                    if addCol == 1  % insert at the beginning 
                        continue;
                        route(addRow,3:midRouteLength+1) = route(addRow,2:midRouteLength);
                        route(addRow,2) = newNode;
                        finish_node_qty = finish_node_qty+1;
                        finish_nodes(newNode) = finish_nodes(newNode) + 1;
                    elseif addCol == midRouteLength % at the end

                        %%%%%
                        temp_route = route(addRow,:);
                        temp_route(1,midRouteLength+1) = newNode;
                        flag = JudgeRoute(temp_route,time_window1, time_window2, depot_time_window2, service_time,dists);
                        if flag == 0
                            continue;
                        end
                        route(addRow,midRouteLength+1) = newNode;

                        finish_node_qty = finish_node_qty + 1;
                        finish_nodes(newNode) = finish_nodes(newNode) + 1;
                    end
                    %end
                else
                    % situation 3
                    % 2 points are in different routes
                    % end of 2 routes
                    route_length_A = max(find(route(rowA(1),:)>1));
                    route_length_B = max(find(route(rowB(1),:)>1));
                    % 2 points are at the beginning of routes
                    if colA(1) == 1 && colB(1) == 1
                        continue;
                        exchange_qty = route_length_B - 1;
                        exchange_route=route(rowB(1),2:route_length_B);
                        % Flip array left to right
                        convert_exchange_route=fliplr(exchange_route);
                        % change the size of route A, and merge two
                        % routes
                        route(rowA(1),exchange_qty+2:exchange_qty+route_length_A) = route(rowA(1),2:route_length_A) ;
                        route(rowA(1),2:exchange_qty+1) = convert_exchange_route;
                        route(rowB(1),:) = 0; % clean route B
                        set_route_qty=set_route_qty - 1;
                    % A is at the beginning and B is at the end
                    elseif colA(1) == 1 && colB(1) == route_length_B
                        exchange_qty = route_length_A - 1;
                        exchange_route = route(rowA(1),2:route_length_A);
                        % add route A to B
                        temp_route = route(rowB(1), :);
                        temp_route(1,route_length_B+1:route_length_B+exchange_qty) = exchange_route;

                        %%%%%
                        flag = JudgeRoute(temp_route,time_window1, time_window2, depot_time_window2, service_time,dists);
                        if flag == 0
                            continue;
                        end
                        route(rowB(1),route_length_B+1:route_length_B+exchange_qty) = exchange_route;
                        % clean route A
                        route(rowA(1),:) = 0; 
                        set_route_qty = set_route_qty - 1;
                    % the same situation
                    elseif colB(1) == 1 && colA(1) == route_length_A
                        exchange_qty = route_length_B - 1;
                        exchange_route = route(1,2:route_length_B);
                        %%%%%
                        temp_route = route(rowA(1), :);
                        temp_route(rowA(1),route_length_A+1:exchange_qty+route_length_A) = exchange_route;
                        flag = JudgeRoute(temp_route,time_window1, time_window2, depot_time_window2, service_time,dists);
                        if flag == 0
                            continue;
                        end
                        route(rowA(1),route_length_A+1:exchange_qty+route_length_A) = exchange_route;
                        route(rowB(1),:) = 0;
                        set_route_qty=set_route_qty-1;
                    % 2 points at the end of routes
                    elseif colA(1) == route_length_A && colB(1) == route_length_B
                        continue;
                        exchange_qty = route_length_B - 1;
                        exchange_route = route(rowB(1),2:route_length_B);
                        convert_exchange_route = fliplr(exchange_route);
                        route(rowA(1),route_length_A+1:route_length_A+exchange_qty) = convert_exchange_route;
                        route(rowB(1),:) = 0;
                        set_route_qty = set_route_qty - 1;
                    end
                    
                end
            end
        end
        
        route = sortrows(route,-1);
        % number of routes
        midIdx = max(find(route(:,1)>0));
        if midIdx ~= set_route_qty
            disp('error 2');
        end
        % situation 4
        % some points are not in the routes
        if finish_node_qty < customer_qty
            need_assign_nodes = find(finish_nodes==0);
            isHas = sum(need_assign_nodes);
            if isHas==0
                disp('error 3');
            end
            unfinish_qty = size(need_assign_nodes,2);
            for j = 1:unfinish_qty
                % one route, one point
                route(set_route_qty+j,1) = need_assign_nodes(j);
            end
        end
        % clean empty routes
        midIdx = find(route(:,1)==0);
        route(midIdx,:) = [];
        % add depots
        [row,col] = size(route);
        % max length of routes
        max_num = 0;
        for i = 1 : row
            mid_val = max(find(route(i,:)>1));
            if mid_val > max_num
                max_num = mid_val;
            end
        end
        % clean zero element
        if max_num < col
            route(:,max_num+1:col) = [];
        end
    end
    
end

