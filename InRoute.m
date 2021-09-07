function [answer, row_id] = InRoute(point_id, routes)
    rows = size(routes, 1);
    answer = 0;
    for i = 1 : rows
        curr_route = routes(i, :);
        if sum(curr_route) > 0
            if point_id == curr_route(1)
                answer = 1;
                row_id = i;
                break;
            else
                last_id = 0;
                for j = size(curr_route, 2) : -1 : 1
                    if curr_route(j) > 0
                        last_id = j;
                        break;
                    end
                end
                if curr_route(last_id) == point_id
                    answer = 2;
                    row_id = i;
                    break;
                end
            end
        end
    end

end