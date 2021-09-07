function route = CWPSaving(dists, sortSaveVal, time_window1, time_window2, depot_time_window2, service_time)
    %parallel saving algorithm
    [row,~] = max(size(dists));
    if row > 2
        % point 1 is depot 
        customerQty = size(dists,1) - 1; 
        % build an empty route 
        route = zeros(customerQty, customerQty+2); 
        
        finishNodeQty = 0;
        setRouteQty = 0;
        % visited nodes
        finishNodes = zeros(1, customerQty);
        %finishNodes(1) = 1;
        % save the capacity for each route
        %routeWeight = zeros(customerQty,1);
        % size of saving array 
        saveRows=size(sortSaveVal,1);
        % 
        for i= 1 : saveRows
            % 2 nodes in a line 
            nodeA = sortSaveVal(i,1)-1;
            nodeB = sortSaveVal(i,2)-1;
            % nodes in route?
            [rowA,colA] = find(route==nodeA);
            [rowB,colB] = find(route==nodeB);
            isFindA = sum(rowA)+sum(colA);
            isFindB = sum(rowB)+sum(colB);
            % no
            % Situation 1
            if isFindA + isFindB == 0
                %sumDmd = xyDmd(nodeA) + xyDmd(nodeB);
                % find an empty route
                midIdx = find(route(:,1) == 0);
                midIdx2 = sum(midIdx);
                if midIdx2 > 0 
                    thisRow = midIdx(1);
                    
                    %%%%
                    temp_route = route(thisRow, :);
                    temp_route(thisRow,1) = nodeA;
                    temp_route(thisRow,2) = nodeB;
                    flag = JudgeRoute(temp_route,time_window1, time_window2, depot_time_window2, service_time,dists);
                    % capacity not violated
                    if flag == 1
                        %route(thisRow,1) = 0; % depot
                        route(thisRow,1) = nodeA;
                        route(thisRow,2) = nodeB;
                        % visted nodes + 2
                        finishNodeQty = finishNodeQty + 2;
                        % used routes
                        setRouteQty = setRouteQty + 1;
                        % 2 nodes has been visted
                        finishNodes(nodeA) = finishNodes(nodeA) + 1;
                        finishNodes(nodeB) = finishNodes(nodeB) + 1;
                        
                        %routeWeight(thisRow) = routeWeight(thisRow) + sumDmd;
                    end
                else
                    disp('error 1');
                end
            % points are already in routes
            elseif isFindA + isFindB > 0
                % Situation 2
                % only one point in a route
                if isFindA * isFindB == 0
                    if isFindA > 0
                        % target and position of insertion
                        newNode = nodeB;
                        addRow = rowA(1); 
                        addCol = colA(1);
                    else
                        newNode = nodeA;
                        addRow = rowB(1); 
                        addCol = colB(1);
                    end
                    % new weight
                    %midWeight = routeWeight(addRow) + xyDmd(newNode);
                    %if midWeight <= truckCap
                        midRouteLength = max(find(route(addRow,:)>1));
                        % insert
                        if addCol == 1  % insert at the beginning 
                            continue;
                            route(addRow,3:midRouteLength+1) = route(addRow,2:midRouteLength);
                            route(addRow,2) = newNode;
                            %routeWeight(addRow) = midWeight; % new weight
                            finishNodeQty = finishNodeQty+1;
                            finishNodes(newNode) = finishNodes(newNode) + 1;
                        elseif addCol == midRouteLength % at the end
                            
                            %%%%%
                            temp_route = route(addRow,:);
                            temp_route(addRow,midRouteLength+1) = newNode;
                            flag = JudgeRoute(temp_route,time_window1, time_window2, depot_time_window2, service_time,dists);
                            if flag == 0
                                continue;
                            end
                            route(addRow,midRouteLength+1) = newNode;
                            %routeWeight(addRow) = midWeight;
                            finishNodeQty = finishNodeQty + 1;
                            finishNodes(newNode) = finishNodes(newNode) + 1;
                        end
                    %end
                else
                    % situation 3
                    % 2 points are in different routes
                    %midWeight = routeWeight(rowA(1)) + routeWeight(rowB(1));
                    % capacity not violated and not in same row
                    %if midWeight <= truckCap && rowA(1) ~= rowB(1)
                        % end of 2 routes
                        midRouteLthA = max(find(route(rowA(1),:)>1));
                        midRouteLthB = max(find(route(rowB(1),:)>1));
                        % 2 points are at the beginning of routes
                        if colA(1) == 1 && colB(1) == 1
                            continue;
                            exchangeQty = midRouteLthB - 1;
                            exchangeRoute=route(rowB(1),2:midRouteLthB);
                            % Flip array left to right
                            exchgRoute=fliplr(exchangeRoute);
                            % change the size of route A, and merge two
                            % routes
                            route(rowA(1),exchangeQty+2:exchangeQty+midRouteLthA) = route(rowA(1),2:midRouteLthA) ;
                            route(rowA(1),2:exchangeQty+1) = exchgRoute;
                            route(rowB(1),:) = 0; % clean route B
                            %routeWeight(rowA(1)) = midWeight;
                            %routeWeight(rowB(1)) = 0;
                            setRouteQty=setRouteQty - 1;
                        % A is at the beginning and B is at the end
                        elseif colA(1) == 1 && colB(1) == midRouteLthB
                            exchangeQty = midRouteLthA - 1;
                            exchangeRoute = route(rowA(1),2:midRouteLthA);
                            % add route A to B
                            temp_route = route(rowB(1), :);
                            temp_route(rowB(1),midRouteLthB+1:midRouteLthB+exchangeQty) = exchangeRoute;
                            
                            %%%%%
                            flag = JudgeRoute(temp_route,time_window1, time_window2, depot_time_window2, service_time,dists);
                            if flag == 0
                                continue;
                            end
                            route(rowB(1),midRouteLthB+1:midRouteLthB+exchangeQty) = exchangeRoute;
                            % clean route A
                            route(rowA(1),:) = 0;
                            %routeWeight(rowB(1)) = midWeight;
                            %routeWeight(rowA(1)) = 0;  
                            setRouteQty = setRouteQty - 1;
                        % the same situation
                        elseif colB(1) == 1 && colA(1) == midRouteLthA
                            exchangeQty = midRouteLthB - 1;
                            exchangeRoute = route(rowB(1),2:midRouteLthB);
                            %%%%%
                            temp_route = route(rowA(1), :);
                            temp_route(rowA(1),midRouteLthA+1:exchangeQty+midRouteLthA) = exchangeRoute;
                            flag = JudgeRoute(temp_route,time_window1, time_window2, depot_time_window2, service_time,dists);
                            if flag == 0
                                continue;
                            end
                            route(rowA(1),midRouteLthA+1:exchangeQty+midRouteLthA) = exchangeRoute;
                            route(rowB(1),:) = 0;
                            %routeWeight(rowA(1)) = midWeight;
                            %routeWeight(rowB(1)) = 0; 
                            setRouteQty=setRouteQty-1;
                        % 2 points at the end of routes
                        elseif colA(1) == midRouteLthA && colB(1) == midRouteLthB
                            continue;
                            exchangeQty = midRouteLthB - 1;
                            exchangeRoute = route(rowB(1),2:midRouteLthB);
                            exchgRoute = fliplr(exchangeRoute);
                            route(rowA(1),midRouteLthA+1:midRouteLthA+exchangeQty) = exchgRoute;
                            route(rowB(1),:) = 0;
                            %routeWeight(rowA(1)) = midWeight;
                            %routeWeight(rowB(1)) = 0; 
                            setRouteQty = setRouteQty - 1;
                        end
                    %end
                end
            end
        end
        
        route = sortrows(route,-1);
        % number of routes
        midIdx = max(find(route(:,1)>0));
        if midIdx ~= setRouteQty
            disp('error 2');
        end
        % situation 4
        % some points are not in the routes
        if finishNodeQty < customerQty
            needAssignNodes = find(finishNodes==0);
            isHas = sum(needAssignNodes);
            if isHas==0
                disp('error 3');
            end
            unFinishQty = size(needAssignNodes,2);
            for j = 1:unFinishQty
                % one route, one point
                %route(setRouteQty+j,1) = 1;
                route(setRouteQty+j,1) = needAssignNodes(j);
            end
        end
        % clean empty routes
        midIdx = find(route(:,1)==0);
        route(midIdx,:) = [];
        % add depots
        [row,col] = size(route);
        % max length of routes
        maxNum = 0;
        for i = 1 : row
            midV = max(find(route(i,:)>1));
            if midV > maxNum
                maxNum = midV;
            end
        end
        % clean zero element
        if maxNum < col
            route(:,maxNum+1:col) = [];
        end
    end
    % clean weight matrix
%     idx = routeWeight==0;
%     routeWeight(idx) = [];
%     singleWeight = routeWeight;
end







