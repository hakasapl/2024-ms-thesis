function segSNR = hSegSNR(x,y,window_size)
    %
    % Remove DC offset
    %

    x = x - mean(x);
    y = y - mean(y);

    %
    % Correct Scale
    %

    Px = max(abs(x));
    Py = max(abs(y));      
    Gp = (Py/Px);

    x = Gp*x;

    %
    % Calculate Segmental SNR
    %

    % Threshold limits for SNR
    eta = (max(max(abs(x)), max(abs(y))) / 512) ^ 2;
    SNRdBMax = 80;
    SNRdBMin = -5;

    max_val = min(length(x), length(y));
    num_windows = floor(max_val/window_size);  % Number of Loops

    SNR = zeros(num_windows,1);

    % Loop window by window
    for i = 1:num_windows
        % Find indices
        a = (i - 1) * window_size + 1;
        b = i * window_size;

        % Create loop vectors
        x_i = x(a:b);
        y_i = y(a:b);

        Px = mean(x_i .^ 2);
        Py = mean(y_i .^ 2);
        Pxmy = mean((x_i - y_i) .^ 2);
        
        if(Px >= eta || Py >= eta)
            if( Px == 0 && Py ~= 0)
                SNR(i) = SNRdBMin;
            elseif (Px ~= 0 && Py == 0)
                SNR(i) = SNRdBMax;
            else
                SNR(i) = pow2db(Px / Pxmy);
            end
        else
            SNR(i) = 0;
        end

        % Fix over-limit values if needed
        if(SNR(i) > SNRdBMax)
            SNR(i) = SNRdBMax;
        end          
        
        if(SNR(i) < SNRdBMin)
            SNR(i) = SNRdBMin;
        end
    
    end
    
    % Average of SNR vector, not counting 0 values
    ix = find(SNR ~= 0);
    segSNR = sum(SNR)/length(ix);
end
