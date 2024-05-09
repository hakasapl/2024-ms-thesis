function [y, xcorr_list] = hWindowXCorr(a, b, window_size, sliding_size)
    max_length = min(length(a), length(b));
    num_windows = floor(max_length / sliding_size);

    xcorr_list = NaN(num_windows - 2, 1);
    for i = 1:num_windows - 2
        idx_a = (i - 1) * sliding_size + 1;
        idx_b = idx_a + window_size;

        a_i = a(idx_a:idx_b);
        b_i = b(idx_a:idx_b);

        a_i = a_i - mean(a_i);
        b_i = b_i - mean(b_i);

        xcorr_list(i) = max(abs(xcorr(a_i, b_i, 'coeff')));
    end

    y = mean(xcorr_list);
end
