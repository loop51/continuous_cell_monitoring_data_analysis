clear;

load('processed_data.mat');

openfig("Processed_Data_Plot.fig");

set_param = 1;



for i=1:size(processedData,1)
    processedData(i, 11) = set_param;  
end

save('processed_data.mat','processedData');
clear;

load('processed_data.mat');