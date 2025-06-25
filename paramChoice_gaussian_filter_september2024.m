baseline.s11m = imgaussfilt(s11m, sigma);
baseline.s21m = imgaussfilt(s21m, sigma);
baseline.s11a = imgaussfilt(s11a, sigma);
baseline.s21a = imgaussfilt(s21a, sigma);

s.s11m = s11m;
s.s11a = s11a;
s.s21m = s21m;
s.s21a = s21a;

[peaks, dS, T, valleySL, valleySR]=function_param_Choice_gaussian_filter(s, x_axis_time, deviation, baseline, paramX);

for i=1:10
    [detrend.s11m, detrend.s11a, detrend.s21m, detrend.s21a] = generate_detrend_line(valleySL.t, valleySR.t, baseline.s11m, baseline.s11a, ...
    baseline.s21m, baseline.s21a, x_axis_time, s11m, s11a, s21m, s21a, detrend_line_averaging);
    clear peaks dS T valleySL valleySR;
    baseline.s11m = detrend.s11m;
    baseline.s11a = detrend.s11a;

    baseline.s21m = detrend.s21m;
    baseline.s21a = detrend.s21a;


    [peaks, dS, T, valleySL, valleySR]=function_param_Choice_gaussian_filter(s, x_axis_time, deviation, detrend, paramX);
end


%% GET THE PEAKS from final detrend
for ii=1:length(T)
    for jj=1:length(x_axis_time)
        if x_axis_time(jj) == T(ii)
            dS.s11m(ii) = s11m(jj) - detrend.s11m(jj);
            dS.s21m(ii) = s21m(jj) - detrend.s21m(jj);
            dS.s11a(ii) = s11a(jj) - detrend.s11a(jj);
            dS.s21a(ii) = s21a(jj) - detrend.s21a(jj);
        end
    end
end



