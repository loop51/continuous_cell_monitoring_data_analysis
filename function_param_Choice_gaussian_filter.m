%% inputs
% here s --> holds the input s11m, s11a, s21m and s21a
% time --> x_axis_time points
% sigma--> for the gaussian filter
% deviation --> how much away from the noise floor
% baseline --> would be the baseline calculated 
% paramX --> which parameter to choose from

%%outputs
% peak --> peak points
% dS --> difference from peak point to the baseline
% T --> time of the peak point
% valleySL --> holds the s11m,s11a,s21m,s21a and time point of the left
% valley point
% valleySR --> holds the s11m,s11a,s21m,s21a and time point of the right
% valley point
%%
function [peaks, dS,T, valleySL, valleySR] = function_param_Choice_gaussian_filter(s, time, deviation, baseline, paramX)
    switch paramX
        case 's11m'
        [dS.s11m, T, valleySL.t, valleySR.t] = gaussian_filter_fetch(s.s11m, time, baseline.s11m, deviation, 1);
        for i=1:length(T)
            for ii=1:length(s.s11a)
                if T(i) == time(ii)
                    peaks.s11m(i) = s.s11m(ii);
                    peaks.s21m(i) = s.s21m(ii);
                    peaks.s11a(i) = s.s11a(ii);
                    peaks.s21a(i) = s.s21a(ii);
        
                    % dS.s11m(i) = peaks.s11m(i) - baseline.s11m(ii);
                    dS.s21m(i) = peaks.s21m(i) - baseline.s21m(ii);
                    dS.s11a(i) = peaks.s11a(i) - baseline.s11a(ii);
                    dS.s21a(i) = peaks.s21a(i) - baseline.s21a(ii);
                    break;
                end
            end
        end
        case 's21m'
            [dS.s21m, T,valleySL.t, valleySR.t] = gaussian_filter_fetch(s.s21m, time, baseline.s21m, deviation, 1);
            for i=1:length(T)
                for ii=1:length(s.s11a)
                    if T(i) == time(ii)
                        peaks.s11m(i) = s.s11m(ii);
                        peaks.s21m(i) = s.s21m(ii);
                        peaks.s11a(i) = s.s11a(ii);
                        peaks.s21a(i) = s.s21a(ii);
            
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
            [dS.s11a, T, valleySL.t, valleySR.t] = gaussian_filter_fetch(s.s11a, time, baseline.s11a, deviation, 1);
            for i=1:length(T)
                for ii=1:length(s.s11a)
                    if T(i) == time(ii)
                        peaks.s11m(i) = s.s11m(ii);
                        peaks.s21m(i) = s.s21m(ii);
                        peaks.s11a(i) = s.s11a(ii);
                        peaks.s21a(i) = s.s21a(ii);
            
                        dS.s11m(i) = peaks.s11m(i) - baseline.s11m(ii);
                        dS.s21m(i) = peaks.s21m(i) - baseline.s21m(ii);
                        % dS.s11a(i) = peaks.s11a(i) - baseline.s11a(ii);
                        dS.s21a(i) = peaks.s21a(i) - baseline.s21a(ii);
                        break;
                    end
                end
            end

        case 's21a'
            [dS.s21a, T, valleySL.t, valleySR.t] = gaussian_filter_fetch(s.s21a, time, baseline.s21a, deviation, 1);
            for i=1:length(T)
                for ii=1:length(s.s11a)
                    if T(i) == time(ii)
                        peaks.s11m(i) = s.s11m(ii);
                        peaks.s21m(i) = s.s21m(ii);
                        peaks.s11a(i) = s.s11a(ii);
                        peaks.s21a(i) = s.s21a(ii);
            
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

    for ii=1:length(valleySL.t)
        for jj=1:length(time)
            if time(jj) == valleySL.t(ii)
                valleySL.s11m(ii) = s.s11m(jj);
                valleySL.s21m(ii) = s.s21m(jj);
                valleySL.s11a(ii) = s.s11a(jj);
                valleySL.s21a(ii) = s.s21a(jj);
                break;
            end
        end
    end
    
    for ii=1:length(valleySR.t)
        for jj=1:length(time)
            if time(jj) == valleySR.t(ii)
                valleySR.s11m(ii) = s.s11m(jj);
                valleySR.s21m(ii) = s.s21m(jj);
                valleySR.s11a(ii) = s.s11a(jj);
                valleySR.s21a(ii) = s.s21a(jj);
                break;
            end                                                                                                                                                     
        end
    end

end