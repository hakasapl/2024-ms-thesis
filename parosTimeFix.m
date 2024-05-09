function y = parosTimeFix(x, col_t, col_d, fs)

    d = x(:,col_d);
    t = x(:,col_t);
    
    ideal_t = transpose(t(1):1/fs:t(end));

    y = zeros(length(ideal_t), 2);
    y(:,1) = ideal_t;
    y(:,2) = interp1(t, d, ideal_t, 'linear');

end
