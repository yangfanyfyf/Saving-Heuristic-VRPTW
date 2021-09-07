function TD = TotalDistance(dists, routes)
    number_route = size(routes, 1);
    TD = 0;
    for i = 1 : number_route
        temp_route = routes(i,:);
        temp_route(find(temp_route == 0)) = [];
        TD = TD + dists(1,temp_route(1)+1);
        for j = 2 : size(temp_route, 2)
            TD = TD + dists(routes(j-1)+1,routes(j)+1);
        end
        TD = TD + dists(routes(end)+1,1);
end