% 假设是
function saving_matrix = SavingDist(dists, tw1, tw2, destination)
    num_customers = size(dists, 1); % 包括了起点
    saving_matrix = zeros(nchoosek(num_customers - 1, 2), 3);
    row = 1;
    for i = 2 : num_customers - 1
        for j = i + 1 : num_customers
            
            if destination(i-1,2) == j
                saving = 10000;
            else
                saving = dists(1,i) + dists(1,j) - dists(i,j);
            end
            % 将开始时间更早的放在前面
            if tw2(i-1) <= tw2(j-1)
                saving_matrix(row, 1:3) = [i, j, saving];
            else
                saving_matrix(row, 1:3) = [j, i, saving];
            end
            row = row + 1;
        end
    end
    saving_matrix = sortrows(saving_matrix, 3, 'descend');
    
%     % 如何将特定的数组放到前面？
%     destination(find(destination(:,2) == -1), :) = [];
%     destination(find(destination(:,2) == -2), :) = [];
%     temp_idx = saving_matrix(:, 1:2);
%     idx = [];
%     for i = 1 : size(temp_idx,1)
%         for j = 1 : size(destination,1)
%             if temp_idx(i,1) == destination(j,1) && temp_idx(i,2) == destination(j,2)
%                 idx = [idx;i];
%                 break;
%             elseif temp_idx(i,1) == destination(j,2) && temp_idx(i,2) == destination(j,1)
%                 temp_val = saving_matrix(i,1);
%                 saving_matrix(i,1) = saving_matrix(i,2);
%                 saving_matrix(i,2) = temp_val;
%                 idx = [idx;i];
%                 break;
%             end
%         end
%     end
%     
% %     Lia = ismember(temp_idx, destination);
% %     idx = Lia(:,1) .* Lia(:,2);
% %     idx = find(idx == 1)
% %     k = 1;
%     for i = 1 : size(idx, 1)
%         temp_array = saving_matrix([i:idx(i)], :);
%         temp_array = circshift(temp_array,1,1);
%         saving_matrix([i:idx(i)], :) = temp_array;
%     end
%     idx1 = saving_matrix(:,1:2) == 18;
%     idx1 = find(idx1(:,1) + idx1(:,2) > 0);
%     saving_matrix(idx1,:) = [];
%     
%     idx2 = saving_matrix(:,1:2) == 17;
%     idx2 = find(idx2(:,1) + idx2(:,2) > 0);
%     saving_matrix(idx2,:) = [];
end