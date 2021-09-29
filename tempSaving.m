% saving matirx = {location1, location2, saved distance}
% 编号顺序包括了起点，不包括1，时间更早的任务在前面
% 如何添加配送任务？
% 检测
% 1. 当第一个点是配送任务时，第二个点不是，那么直接跳过
% 2. 当第二个点是配送任务，那么直接再加上目标点
% 3. 当第一个点是配送目标点，无法新建旧的路径，尝试直接加上已有路径？
% 4. 
function route = tempSaving(dists, saving_matrix, tw1, tw2, start_tw1, start_tw2, st, desti)
    task_qty = size(dists, 1) - 1;
    route = zeros(task_qty, task_qty + 2); % 空路径
    visited_qty = 0; % 已访问数目
    route_qty = 0; % 非空路径数目
    visited_tasks = zeros(1, task_qty); % 已访问任务计数
    save_rows = size(saving_matrix, 1); % saving_matrix 行数
    % 只考虑时间窗，不考虑送货任务
    for i = 1 : save_rows
        flag = 0;
        node_A = saving_matrix(i, 1) - 1; % 去掉起点， A的时间一定更早
        node_B = saving_matrix(i, 2) - 1;
        
        [row_A, col_A] = find(route == node_A);
        [row_B, col_B] = find(route == node_B);
        find_A = sum(row_A) + sum(col_A);
        find_B = sum(row_B) + sum(col_B);
        
        if find_A + find_B == 0 % 未找到
            
            temp_idx = find(route(:,1) == 0); % route中的空路径
            empty_row = temp_idx(1);
            if empty_row > 0
                
                temp_route = route(empty_row,:);
                temp_route(1,1) = node_A;
                temp_route(1,2) = node_B;
                flag = JudgeRoute(temp_route, tw1, tw2, start_tw2, st, dists);
                if flag == 1
                    route(empty_row, :) = temp_route;
                    visited_qty = visited_qty + 2;
                    route_qty = route_qty + 1;
                    visited_tasks(node_A) = visited_tasks(node_A) + 1;
                    visited_tasks(node_B) = visited_tasks(node_B) + 1;
                end
            end
        elseif find_A + find_B > 0
            % 只找到了一个点
            if find_A * find_B == 0
                if find_A > 0 %找到A
                    new_node = node_B;
                    insert_row = row_A(1);
                    insert_col = col_A(1);
                    % A的时间更早，所以B点只能插在最后
                    insert_route_length = max(find(route(insert_row, :) > 0));
                    if insert_col  == insert_route_length
                        temp_route = route(insert_row,:);
                        temp_route(1,insert_col + 1) = new_node;
                        flag = JudgeRoute(temp_route, tw1, tw2, start_tw2, st, dists);
                        if flag == 1
                            route(insert_row,:) = temp_route;
                            visited_qty = visited_qty + 1;
                            visited_tasks(new_node) = visited_tasks(new_node) + 1;
                        end
                    end 
                else % 找到B， B点需要在队首，然后将A点插到最前面
                    new_node = node_A;
                    insert_row = row_B(1);
                    insert_col = col_B(1);
                    if insert_col == 1
                        temp_route = route(insert_row,:);
                        temp_route = [new_node, temp_route];
                        % 问题
                        temp_route(end) = [];
                        flag = JudgeRoute(temp_route, tw1, tw2, start_tw2, st, dists);
                        if flag == 1
                            route(insert_row,:) = temp_route;
                            visited_qty = visited_qty + 1;
                            visited_tasks(new_node) = visited_tasks(new_node) + 1;
                        end
                    end
                end
            else % 两者都不为0
                % node_A在队尾，node_B在队首
                route_length_A = max(find(route(row_A(1),:)>1));
                route_length_B = max(find(route(row_B(1),:)>1));
                if col_A(1) == route_length_A && col_B(1) == 1
                    % 将rowB放到rowA后面
                    temp_route = route(row_A(1),:);
                    temp_route(1,route_length_A+1 : route_length_A + route_length_B) = route(row_B(1), 1:route_length_B);
                    flag = JudgeRoute(temp_route, tw1, tw2, start_tw2, st, dists);
                    if flag == 1
                        route(row_A(1), :) = temp_route;
                        route(row_B(1), :) = 0;
                        route_qty = route_qty - 1;
                    end
                end
            end
        end
        
    end
    % clean 0 line
    temp_idx = find(route(:,1)==0);
    route(temp_idx, :) = [];
    % 遍历了所有的点，将没有被遍历过的点单独算作一行
    if visited_qty < task_qty
        unvisited_tasks = find(visited_tasks == 0);
        unvisited_qty = size(unvisited_tasks,2);
        for j = 1 : unvisited_qty
            route(route_qty + j, 1) = unvisited_tasks(j)
        end
    end
%     % clean 0 line
%     temp_idx = find(route(:,1)==0);
%     route(temp_idx, :) = [];
    
    % clean 0 column
    [row,col] = size(route);
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