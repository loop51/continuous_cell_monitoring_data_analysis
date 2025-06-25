clc
clear;
close;
%% constants
X = pwd;
X = string(regexp(X, 'set\d*', 'match'));
set = str2num(regexp(X, '\d*', 'match'));
sigma = 1700;
deviation =3;
% detrend_sigma = 100; % this is not relivant as of August 22nd
detrend_line_averaging = 200; % defines the N that repeats to adjust for the signal width
paramX = 's11a'; % either s11m, s21m, s11a, s21a

lp_cutoff = 50;
IFBW = 500;
%% get data 
temp =  dir('**/*S11');
data_s11 = csvread(temp.name);
temp =  dir('**/*S21');
data_s21 = csvread(temp.name);
temp = dir('**/*_x_axis_time');
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

%%
%new stuff

%solves for trend of signal using EMD method. It only takes one column
%vector as an input, and it outputs the trend of that vector
function [trend_] = trend_using_emd(signal)
    %applies built-in MATLAB emd function to 
    [imf,r] = emd(signal);
    num_of_imfs = size(imf,2);
    k = ceil(num_of_imfs/4);
    trend = r;
    for p=1:k
        trend = trend+imf(:,end-p+1);
    end
    trend_ = trend;
end


%% apply low pass filter
order = 10;
framelen = 201;
Ts = x_axis_time(2) - x_axis_time(1);
fs = 1/Ts;
% 
% s11m = lowpass(s11m,lp_cutoff, IFBW,ImpulseResponse="iir",Steepness=0.95);
% s21m = lowpass(s21m,lp_cutoff, IFBW,ImpulseResponse="iir",Steepness=0.95);
% s11a = lowpass(s11a,lp_cutoff, IFBW,ImpulseResponse="iir",Steepness=0.95);
% s21a = lowpass(s21a,lp_cutoff, IFBW,ImpulseResponse="iir",Steepness=0.95);
filter_s11a = sgolayfilt(s11a, order, framelen);


figure();
num_of_plots = 12;
subplot(num_of_plots,1,1);
plot(x_axis_time, s11a);
hold on;
grid on;
plot(x_axis_time, filter_s11a, 'r');

[imf,r] = emd(filter_s11a);
num_of_imfs = size(imf,2);

for i=1:num_of_imfs
    subplot(num_of_plots,1,i+1);

    hold on;
    plot(x_axis_time, imf(:,i));
    grid on;

end

subplot(num_of_plots,1, num_of_plots)
plot(x_axis_time, r);
grid on;

%%
sigma = 100;
gaussian_s11a = imgaussfilt(s11a, sigma);
figure();
trend = trend_using_emd(filter_s11a);

plot(x_axis_time,filter_s11a);
hold on;
plot(x_axis_time,trend);
grid on;
plot(x_axis_time,gaussian_s11a);
grid on;

%%
figure();
Y = fft(filter_s11a);
L = length(filter_s11a);

% plot(fs/L*(0:L-1), abs(Y));
plot(abs(Y))
grid on;
% plot(x_axis_time,highpass(filter_s11a,100, fs));