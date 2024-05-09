function y = parosAlignTimestamps(fs, delay, varargin)
    num_source = length(varargin);
    y = cell(1, num_source);
    t_limits = [-inf inf];
    delay_s = delay / fs;

    % Find bounds of timestamps
    for i = 1:num_source
        i_t = varargin{i}(:,1);

        min_i = min(i_t);
        if min_i > t_limits(1)
            t_limits(1) = min_i;
        end

        max_i = max(i_t);
        if max_i < t_limits(2)
            t_limits(2) = max_i;
        end
    end

    % Find indices of bounds
    for i = 1:num_source
        m_i = varargin{i};
        i_t = m_i(:,1);
        i_d = m_i(:,2);

        if i == 1
            min_idx_i = find(m_i >= t_limits(1) + delay_s & m_i <= t_limits(2) + delay_s);
        else
            min_idx_i = find(m_i >= t_limits(1) & m_i <= t_limits(2));
        end
        
        y{i} = [i_t(min_idx_i) i_d(min_idx_i)];
    end
end
