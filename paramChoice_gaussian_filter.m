baseline.s11m = imgaussfilt(s11m, sigma);
baseline.s21m = imgaussfilt(s21m, sigma);
baseline.s11a = imgaussfilt(s11a, sigma);
baseline.s21a = imgaussfilt(s21a, sigma);

peaks.s11m = 0;
peaks.s11a=0;
peaks.s21m = 0;
peaks.s21a=0;

switch paramX
    case 's11m'
        [dS.s11m, T, Tl, Tr] = gaussian_filter_fetch(s11m, x_axis_time, sigma, deviation, 1);
        for i=1:length(T)
            for ii=1:length(s11a)
                if T(i) == x_axis_time(ii)
                    peaks.s11m(i) = s11m(ii);
                    peaks.s21m(i) = s21m(ii);
                    peaks.s11a(i) = s11a(ii);
                    peaks.s21a(i) = s21a(ii);
        
                    % dS.s11m(i) = peaks.s11m(i) - baseline.s11m(ii);
                    dS.s21m(i) = peaks.s21m(i) - baseline.s21m(ii);
                    dS.s11a(i) = peaks.s11a(i) - baseline.s11a(ii);
                    dS.s21a(i) = peaks.s21a(i) - baseline.s21a(ii);
                    break;
                end
            end
        end
    case 's21m'
        [dS.s21m, T, Tl, Tr] = gaussian_filter_fetch(s21m, x_axis_time, sigma, deviation, 1);
        for i=1:length(T)
            for ii=1:length(s11a)
                if T(i) == x_axis_time(ii)
                    peaks.s11m(i) = s11m(ii);
                    peaks.s21m(i) = s21m(ii);
                    peaks.s11a(i) = s11a(ii);
                    peaks.s21a(i) = s21a(ii);
        
                    dS.s11m(i) = peaks.s11m(i) - baseline.s11m(ii);
                    % dS.s21m(i) = peaks.s21m(i) - baseline.s21m(ii);
                    dS.s11a(i) = peaks.s11a(i) - baseline.s11a(ii);
                    dS.s21a(i) = peaks.s21a(i) - baseline.s21a(ii);
                    break;
                end
            end
        end

    case 's11a'
        % to get S11 phase angle
        [dS.s11a, T, Tl, Tr] = gaussian_filter_fetch(s11a, x_axis_time, sigma, deviation, 1);
        for i=1:length(T)
            for ii=1:length(s11a)
                if T(i) == x_axis_time(ii)
                    peaks.s11m(i) = s11m(ii);
                    peaks.s21m(i) = s21m(ii);
                    peaks.s11a(i) = s11a(ii);
                    peaks.s21a(i) = s21a(ii);
        
                    dS.s11m(i) = peaks.s11m(i) - baseline.s11m(ii);
                    dS.s21m(i) = peaks.s21m(i) - baseline.s21m(ii);
                    % dS.s11a(i) = peaks.s11a(i) - baseline.s11a(ii);
                    dS.s21a(i) = peaks.s21a(i) - baseline.s21a(ii);
                    break;
                end
            end
        end
    case 's21a'
        [dS.s21a, T, Tl, Tr] = gaussian_filter_fetch(s21a, x_axis_time, sigma, deviation, 1);
        for i=1:length(T)
            for ii=1:length(s11a)
                if T(i) == x_axis_time(ii)
                    peaks.s11m(i) = s11m(ii);
                    peaks.s21m(i) = s21m(ii);
                    peaks.s11a(i) = s11a(ii);
                    peaks.s21a(i) = s21a(ii);
        
                    dS.s11m(i) = peaks.s11m(i) - baseline.s11m(ii);
                    dS.s21m(i) = peaks.s21m(i) - baseline.s21m(ii);
                    dS.s11a(i) = peaks.s11a(i) - baseline.s11a(ii);
                    % dS.s21a(i) = peaks.s21a(i) - baseline.s21a(ii);
                    break;
                end
            end
        end

    otherwise
        warning('Unexpected S-parameter, check paramX value');
end


%% fetch the corresponding signal points for valleys
for ii=1:length(Tl)
    for jj=1:length(x_axis_time)
        if x_axis_time(jj) == Tl(ii)
            vl.s11m(ii) = s11m(jj);
            vl.s21m(ii) = s21m(jj);
            vl.s11a(ii) = s11a(jj);
            vl.s21a(ii) = s21a(jj);
            break;
        end
    end
end

for ii=1:length(Tr)
    for jj=1:length(x_axis_time)
        if x_axis_time(jj) == Tr(ii)
            vr.s11m(ii) = s11m(jj);
            vr.s21m(ii) = s21m(jj);
            vr.s11a(ii) = s11a(jj);
            vr.s21a(ii) = s21a(jj);
            break;
        end                                                                                                                                                     
    end
end
%% as of August 22nd I am replacing thism I drafted a function called generate_detrend_line that will
% repeat this detrending N times to get a smooth detrended line
% %% remove the signals and replace it with average of Tl and Tr value
    % % bn--> background noise
    % bn.s11m = zeros(length(x_axis_time),1);
    % bn.s21m = zeros(length(x_axis_time),1);
    % bn.s11a = zeros(length(x_axis_time),1);
    % bn.s21a = zeros(length(x_axis_time),1);
    % for ii=1:length(Tr)
    %     for jj=1:length(x_axis_time)
    %         if x_axis_time(jj) >= Tl(ii) && x_axis_time(jj) <= Tr(ii)
    %             bn.s11m(jj) = (vl.s11m(ii) + vr.s11m(ii))/2;
    %             bn.s21m(jj) = (vl.s21m(ii) + vr.s21m(ii))/2;
    %             bn.s11a(jj) = (vl.s11a(ii) + vr.s11a(ii))/2;
    %             bn.s21a(jj) = (vl.s21a(ii) + vr.s21a(ii))/2;
    %         % else
    %             % bn.s11m(jj) = s11m(jj);
    %             % bn.s21m(jj) = s21m(jj);
    %             % bn.s11a(jj) = s11a(jj);
    %             % bn.s21a(jj) = s21a(jj);
    %         end
    % 
    %     end
    % end
    % 
    % for ii=1:length(x_axis_time)
    %     if bn.s11m(ii) == 0
    %         bn.s11m(ii) = s11m(ii);
    %         bn.s21m(ii) = s21m(ii);
    %         bn.s11a(ii) = s11a(ii);
    %         bn.s21a(ii) = s21a(ii);
    %     end
    % 
    % end
    % %% detrend the data
    % % detrend_sigma = 200;
    % detrend.s11m = imgaussfilt(bn.s11m, detrend_sigma);
    % detrend.s21m = imgaussfilt(bn.s21m, detrend_sigma);
    % detrend.s11a = imgaussfilt(bn.s11a, detrend_sigma);
    % detrend.s21a = imgaussfilt(bn.s21a, detrend_sigma);
    % 
    
[detrend.s11m, detrend.s11a, detrend.s21m, detrend.s21a] = generate_detrend_line(Tl, Tr, baseline.s11m, baseline.s11a, ...
    baseline.s21m, baseline.s21a, x_axis_time, s11m, s11a, s21m, s21a, detrend_line_averaging);

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



