function [y, out_noise_windows, out_data_windows, out_weights] = parosNoiseCancel(n, d, window_size, order, repAdapt, mu, chi, minRefPower)
    % Window by window
    max_length = min(length(n), length(d));
    num_windows = floor(max_length / window_size);
    max_output_length = num_windows * window_size;

    out_noise_windows = zeros(window_size, num_windows);
    out_data_windows = zeros(window_size, num_windows);
    out_weights = zeros(order, num_windows);
    y = zeros(1, max_output_length);

    % Loop for each window
    last_h = zeros(order, 1);

    for i = 1:num_windows
        % Create Window
        a = (i - 1) * window_size + 1;
        b = a + window_size - 1;
        n_i = n(a:b);
        d_i = d(a:b);

        % Remove DC Offset
        n_i = n_i - mean(n_i);
        d_mean = mean(d_i);
        d_i = d_i - d_mean;

        % Save current xcorr
        out_noise_windows(:,i) = transpose(n_i);
        out_data_windows(:,i) = transpose(d_i);

        % NLMS Adaptive Filter
        [e, ~, last_h] = hLMS(n_i, d_i, order, 1, repAdapt, mu, chi, minRefPower, last_h);

        % Add mean back in
        y(a:b) = e + d_mean;

        out_weights(:,i) = last_h;
    end
end
