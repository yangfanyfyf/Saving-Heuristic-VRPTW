function saving_array = SavingDist(dists)
    num_customers = size(dists, 1);
    saving_array = zeros(nchoosek(num_customers - 1, 2), 3);
    row = 1;
    for i = 2 : num_customers - 1
        for j = i + 1 : num_customers
            saving = dists(1,i) + dists(1,j) - dists(i,j);
            saving_array(row, 1:3) = [i, j, saving];
            row = row + 1;
        end
    end
    saving_array = sortrows(saving_array, 3, 'descend');
end