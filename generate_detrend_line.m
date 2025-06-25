% here the return values of s11m, s11a, s21m, s21a are the actual detrend
% data
% detrend_sigma = 70; as default but can be changed on line 63
% b_ stands for baseline with basic gaussian filter
% r_ stands for the raw signals
function [s11m, s11a, s21m, s21a] = generate_detrend_line(Tl, Tr, b_s11m, b_s11a, b_s21m, b_s21a, ...
    x_axis_time, r_s11m, r_s11a, r_s21m, r_s21a, N)
    for abc=1:N
        %% fetch the corresponding signal points for valleys from baseline signal
            for ii=1:length(Tl)
                for jj=1:length(x_axis_time)
                    if x_axis_time(jj) == Tl(ii)
                        vl.s11m(ii) = b_s11m(jj);
                        vl.s21m(ii) = b_s21m(jj);
                        vl.s11a(ii) = b_s11a(jj);
                        vl.s21a(ii) = b_s21a(jj);
                        break;
                    end
                end
            end
            
            for ii=1:length(Tr)
                for jj=1:length(x_axis_time)
                    if x_axis_time(jj) == Tr(ii)
                        vr.s11m(ii) = b_s11m(jj);
                        vr.s21m(ii) = b_s21m(jj);
                        vr.s11a(ii) = b_s11a(jj);
                        vr.s21a(ii) = b_s21a(jj);
                        break;
                    end                                                                                                                                                     
                end
            end
        %% remove the signals and replace it with average of Tl and Tr value
            % bn--> background noise
            bn.s11m = zeros(length(x_axis_time),1);
            bn.s21m = zeros(length(x_axis_time),1);
            bn.s11a = zeros(length(x_axis_time),1);
            bn.s21a = zeros(length(x_axis_time),1);
            for ii=1:length(Tr)
                for jj=1:length(x_axis_time)
                    if x_axis_time(jj) >= Tl(ii) && x_axis_time(jj) <= Tr(ii)
                        bn.s11m(jj) = (vl.s11m(ii) + vr.s11m(ii))/2;
                        bn.s21m(jj) = (vl.s21m(ii) + vr.s21m(ii))/2;
                        bn.s11a(jj) = (vl.s11a(ii) + vr.s11a(ii))/2;
                        bn.s21a(jj) = (vl.s21a(ii) + vr.s21a(ii))/2;
                    % else
                        % bn.s11m(jj) = s11m(jj);
                        % bn.s21m(jj) = s21m(jj);
                        % bn.s11a(jj) = s11a(jj);
                        % bn.s21a(jj) = s21a(jj);
                    end
            
                end
            end
            
            for ii=1:length(x_axis_time)
                if bn.s11m(ii) == 0
                    bn.s11m(ii) = r_s11m(ii);
                    bn.s21m(ii) = r_s21m(ii);
                    bn.s11a(ii) = r_s11a(ii);
                    bn.s21a(ii) = r_s21a(ii);
                end
            
            end
        %% detrend the data
            detrend_sigma = 100;
            b_s11m = imgaussfilt(bn.s11m, detrend_sigma);
            b_s21m = imgaussfilt(bn.s21m, detrend_sigma);
            b_s11a = imgaussfilt(bn.s11a, detrend_sigma);
            b_s21a = imgaussfilt(bn.s21a, detrend_sigma);
    end
%% assign the outputs
    s11m = b_s11m;
    s11a = b_s11a;
    s21m = b_s21m;
    s21a = b_s21a;
end