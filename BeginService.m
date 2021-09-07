function [arr,bs,wait,back] = BeginService(route,time_window1,service_time,dists)
  %route(find(route == 0)) = [];

  n = length(route);
  arr = zeros(1,n); 
  bs = zeros(1,n); 
  wait = zeros(1,n);
  
  arr(1) = dist(1,route(1)+1); % the dist between the depot and the first customer,
  bs(1) = max(time_window1(route(1)),dists(1,route(1)+1));
  wait(1) = bs(1)-arr(1);
  for i = 1:n
      if i ~= 1
          % arrival time = begin time of (i - 1) + service time of (i - 1) + distance between i - 1 and i
          arr(i) = bs(i-1) + service_time(route(i-1)) + dists(route(i-1)+1,route(i)+1);
          % if the arrival time is earlier, then the start time is the left time window
          bs(i) = max(time_window1(route(i)), arr(i));
          wait(i) = bs(i) - arr(i);
      end
  end
  % back to the depot
  back = bs(end) + service_time(route(end)) + dists(route(end)+1,1);
  
end