
%%

clearvars -except folders_to_check main_folder abc working_folder;
close all;
%% constants
X = pwd;
X = string(regexp(X, 'set\d*', 'match'));
set = str2num(regexp(X, '\d*', 'match'));
sigma = 300;
deviation =1.1;
% detrend_sigma = 100; % this is not relivant as of August 22nd
detrend_line_averaging = 10; % defines the N that repeats to adjust for the signal width
paramX = 's21m'; % either s11m, s21m, s11a, s21a

order = 10;
framelen = 41;

lp_cutoff = 50;
IFBW = 500;
%% get data 
temp =  dir('**/*S11');
temp = only_get_main_folder(temp);
data_s11 = csvread(temp.name);
temp =  dir('**/*S21');
temp = only_get_main_folder(temp);
data_s21 = csvread(temp.name);
temp = dir('**/*_x_axis_time');
temp = only_get_main_folder(temp);
x_axis_time = csvread(temp.name);


file_name = temp.name;

parsed = regexp(file_name, '\_', 'split');

date_stamp = string(parsed(1));

SenseType = string(parsed(4));

CW_Freq = parsed(6);
CW_Freq = str2num(string(CW_Freq)) *1e9;
NumPoints = size(data_s11,2);
y_axis_range = 0.0025;


% time_interval = end_time-init_time;
% x_axis_time = milliseconds(time_interval/NumPoints:time_interval/NumPoints:time_interval);
% x_axis_time = seconds(0:Time_point_IFBW/NumPoints:(Time_point_IFBW-(Time_point_IFBW/NumPoints)));

% x_axis_time = seconds(0:43/NumPoints:(43-43/NumPoints));

%% convert to dB and degrees

s11m = 20*log10(abs(data_s11));
s21m = 20*log10(abs(data_s21));
s11a = rad2deg(angle(data_s11));
s21a = rad2deg(angle(data_s21));

%% apply low pass filter

s11m = sgolayfilt(s11m, order, framelen);
s21m = sgolayfilt(s21m, order, framelen);
s11a = sgolayfilt(s11a, order, framelen);
s21a = sgolayfilt(s21a, order, framelen);

%% apply actual filter 

paramChoice_gaussian_filter_september2024;



%% plot s11m with annotations
subplot(2,2,1);
% plot(x_axis_time, s11m,'o');
plot(x_axis_time, s11m);
hold on;
for i = 1:length(dS.s11m)
    text((T(i)), peaks.s11m(i), {num2str(dS.s11m(i)), num2str((T(i)))});
end

grid on;
grid minor;
% plot(x_axis_time, baseline.s11m, 'y');
plot(x_axis_time, detrend.s11m);
% plot(T, peaks.s11m, 'o');

plot(valleySL.t, valleySL.s11m, 'ko');
plot(valleySR.t, valleySR.s11m, 'ko');

% plot(x_axis_time, bn.s11m, ' r');

ylabel('|S11| in dB');
xlabel('time in seconds');

%% plot s11a with annotations
subplot(2,2,2);
% plot(x_axis_time, s11a, 'o');
plot(x_axis_time, s11a);
for i = 1:length(dS.s11a)
    text((T(i)), peaks.s11a(i), {num2str(dS.s11a(i)), num2str((T(i)))});
end
hold on;
grid on;
grid minor;
% plot(x_axis_time, baseline.s11a);
plot(x_axis_time, detrend.s11a);

plot(valleySL.t, valleySL.s11a, 'ko');
plot(valleySR.t, valleySR.s11a, 'ko');


% plot(x_axis_time, bn.s11a, ' r');
ylabel('\angleS11 in degrees');
xlabel('time in seconds');

%% plot s21m with annotations
subplot(2,2,3);
% plot(x_axis_time, s21m,'o');
plot(x_axis_time, s21m);
for i = 1:length(dS.s21m)
    text((T(i)), peaks.s21m(i), {num2str(dS.s21m(i)), num2str((T(i)))});
end
hold on;
grid on;
grid minor;
% plot(x_axis_time, baseline.s21m);
plot(x_axis_time, detrend.s21m);

plot(valleySL.t, valleySL.s21m, 'ko');
plot(valleySR.t, valleySR.s21m, 'ko');

% plot(x_axis_time, bn.s21m, ' r');

ylabel('|S21| in dB');
xlabel('time in seconds');

%% plot s21a with annotaions
subplot(2,2,4);
% plot(x_axis_time, s21a,'o');
plot(x_axis_time, s21a);
for i = 1:length(dS.s21a)
    text((T(i)), peaks.s21a(i), {num2str(dS.s21a(i)), num2str((T(i)))});
end
hold on;
grid on;
grid minor;
% plot(x_axis_time, baseline.s21a);
plot(x_axis_time, detrend.s21a);

plot(valleySL.t, valleySL.s21a, 'ko');
plot(valleySR.t, valleySR.s21a, 'ko');


% plot(x_axis_time, bn.s21a, ' r');
ylabel('\angleS21 in degrees');
xlabel('time in seconds');

%% lock x axis
ax1 = subplot(2,2,1);
ax2 = subplot(2,2,2);
ax3 = subplot(2,2,3);
ax4 = subplot(2,2,4);

linkaxes([ax1,ax2,ax3,ax4],'x');

temp = "Processed_Data_Plot";
saveas(gcf, strcat(temp,'.fig'),'fig');

%% extract the time from text file 
fileID = fopen('Experiment_Log.txt', 'r');

% Read the first line of the file
firstLine = fgetl(fileID);

% Close the file
fclose(fileID);

% Define the regular expression to extract the date and time
pattern = 'Data Acquisition Start Time = (\d{2}-\w{3}-\d{4}) (\d{2}:\d{2}:\d{2}\.\d{3})';

% Apply the regular expression to the first line
tokens = regexp(firstLine, pattern, 'tokens');

% Extract the date and time strings from the tokens
dateStr = tokens{1}{1};
timeStr = tokens{1}{2};

% Combine the date and time strings
dateTimeStr = [dateStr ' ' timeStr];

% Convert the combined date and time string to a MATLAB datetime object
dateTime = datetime(dateTimeStr, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss.SSS');

% Extract individual components
year = year(dateTime);
month = month(dateTime);
day = day(dateTime);
hour = hour(dateTime);
minute = minute(dateTime);
second = second(dateTime);

% Display the extracted components
% disp(['Year: ', num2str(year)]);
% disp(['Month: ', num2str(month)]);
% disp(['Day: ', num2str(day)]);
% disp(['Hour: ', num2str(hour)]);
% disp(['Minute: ', num2str(minute)]);
% disp(['Second: ', num2str(second)]);

init_time = datetime(year, month, day, hour, minute, second);
init_time.Format = 'dd-MMM-uuuu HH:mm:ss.SSS';
init_time;
%% save the data
% data = [0 0 0 0 0 0 0 0 0 0 0];
clear processedData;
gap =0;
index = 1;
% absolute_time = zeros(length(T));
for ii=1:length(T)
    absolute_time(ii) = datenum(init_time + seconds(T(ii)));
end
for i=1:length(T)
    processedData(i,:) = [set deviation sigma absolute_time(i) (T(i)) dS.s11m(i) dS.s11a(i) dS.s21m(i) dS.s21a(i) gap index];
    % processedData(i,:) = [set deviation sigma (T(i)) dS.s11m(i) dS.s11a(i) dS.s21m(i) dS.s21a(i) gap index];
end

save('processed_data.mat','processedData');


%%
function [nama] = only_get_main_folder(temp)
    cf = pwd;
    more_temp = temp;
    for ii=1:length(more_temp)
        if string(more_temp(ii).folder) == string(cf)
            temp = more_temp(ii);
        end
    end
    nama = temp;
end

