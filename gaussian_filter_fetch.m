% here, 
% B --> baseline for this signal
function [deltaS, T, Tl, Tr] = gaussian_filter_fetch(data, t, B, deviation, polarity)


    data= polarity * data;

%     A = imgaussfilt(data,1);
    % here A is the raw data,
    A = data;

    % here B is basically the baseline. 
    % B = imgaussfilt(data,sigma);
    X = abs(A-B); % adding the abs on feb 28th 2024, 
    % idea is this would make the peak extraction polarity of the signal
    % independent
    
    data_std = std(X);

    valley_point_cutoff = data_std*0.1;

    flag_in_peak = 0;
    data_peaks = 0;
    deltaS= 0;
    T = 0;
    data_peaks_time = 0;
    j=1;
    k=1;
    % here i loop through all data points (main data)
    % if it find points that are above a certain standard deviation away 
    % from the gaussian filter/moving average, 
    % then it sets the variable to "flag_in_peak to 1"

    % then after the first if statement, it checks if "flags_in_peak is 1
    % it then populates the variable data_peaks-- which is an array, 

    % so basically as long as you have data points higher than the 
    % moving average- they are fed into the data_peaks array

    % now when the data is not above a certain standard deviation
    % it finds the maximum of data_peaks 
    % then sets the data_peaks array to 0 
    
    % then cycles through again to find the next set of such values
    for i=1:length(data)
        if((X(i)) > data_std*deviation)
            flag_in_peak =1;
        else
            if length(data_peaks) >1
                deltaS(k) = max(data_peaks);
                for ii=1:length(data_peaks)
                    if deltaS(k) == data_peaks(ii)
                        T(k) = data_peaks_time(ii);
                        data_peaks = 0;
                        data_peaks_time = 0;
                        j=1;
                        break;
                    end
                end
                k=k+1;
                flag_in_peak=0;
            end
        end
        if flag_in_peak
            data_peaks(j) = X(i);
            data_peaks_time(j) = t(i);
            j=j+1;
        end
    end
    deltaS = deltaS * polarity;



    % find the number of points 1 standard deviation away 
    % from the peak point both left side and right side
    for ii=1:length(deltaS)
        for jj=1:length(data)
            if T(ii) == t(jj)
                l = jj;
                r = jj;
                while(X(l) > valley_point_cutoff)
                    if l == 1
                        break;
                    else
                        l = l - 1;
                    end
                end
                while(X(r) > valley_point_cutoff)
                    if r == length(data)
                        break;
                    else
                        r = r + 1;
                    end
                end
                Nl(ii) = jj-l;
                Nr(ii) = r - jj;
            end
        end
    end
    % now from Nl and Nr find Tl and Tr
    for ii=1:length(deltaS)
        for jj=1:length(t)
            if t(jj) == T(ii)
                Tl(ii) = t(jj-Nl(ii));
                Tr(ii) = t(jj+Nr(ii));
                break;
            end
        end
        
    end

    
    % now, need to find the exact peak difference points
    % without the abs
    for ii=1:length(deltaS)
        for jj=1:length(data)
            if T(ii) == t(jj)
                detaS(ii) = data(jj) - B(jj);         
            end
        end
    end
end