clc;clear; close all;
test_data = importdata('my_test_data_10.xlsx');
depot_time_window1 = TimeTrans(test_data(1,4)); % time window of depot
depot_time_window2 = TimeTrans(test_data(1,5));
vertexs = test_data(:,2:3); 
customer = vertexs(2:end,:); % customer locations
customer_number = size(customer,1);
% vehicle_number = 25;
time_window1 = TimeTrans(test_data(2:end,4));
time_window2 = TimeTrans(test_data(2:end,5));
width = time_window2 - time_window1; % width of time window
service_time = TimeTrans(test_data(2:end,6)+8); 
h = pdist(vertexs);
dists = squareform(h);
destination = [[1:customer_number]' ,test_data(2:end, 7)];
destination(:,1) = destination(:,1) + 1;
for i = 1 : size(destination,1)
    if destination(i,2) ~= -1 && destination(i,2) ~= -2
        destination(i,2) = destination(i,2) + 1;
    end
end

% calculate the saving dist
saving_matrix = SavingDist(dists,time_window1,time_window2, destination);
routes = tempSaving(dists, saving_matrix, time_window1, time_window2, depot_time_window1, depot_time_window2, service_time, destination)
TD = TotalDistance(dists, routes)