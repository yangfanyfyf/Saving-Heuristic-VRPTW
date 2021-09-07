clc;clear; close all;
test_data = importdata('my_test_data_30.xlsx');
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

% calculate the saving dist
saving_array = SavingDist(dists);
routes = CWPSaving(dists, saving_array, time_window1, time_window2, depot_time_window2, service_time);

TD = TotalDistance(dists, routes)