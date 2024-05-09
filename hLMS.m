function [yOut, w, h_coeff] = hLMS(x, y, Nh, algo, repAdapt, mu, chi, minRefPower, initial)
    % hLMS outputs a signal yOut, where that signal is the noise cancelled version of y, with the noise signal being x
    % Nh: Filter order
    % algo: 0 = LMS, 1 = NLMS
    % repAdapt: Repeated adaptations
    % mu: Step Size
    % chi: 
    % minRefPower: minimum power required to perform noise cancellation

    % Find Lengths of Input Vectors
    L_x = length(x);
    L_y = length(y);
    L = min(L_x, L_y);

    % Initialize h coefficients and shift register
    if exist('initial','var')
        h_coeff = initial;
    else
        h_coeff = zeros(Nh,1);
    end
    
    w = zeros(Nh,L);
    shiftReg_x = zeros(Nh,1);
    
    % prepare storage for output
    yOut = zeros(L,1);

    i = 1;

    %
    % Convergence Loop
    %
    while i <= L

        % update shift register(s)
        shiftReg_x = [x(i); shiftReg_x(1:Nh - 1)];

        rk = repAdapt;
        while rk > 0
            rk = rk - 1;  % decrement tracker var
            
            % calculate residual echo (error)            
            delta = h_coeff' * shiftReg_x;
            err = y(i) - delta;
            
            % Update coefficients
            h_update = mu * shiftReg_x * conj(err);

            if algo == 1
                % if Normalized LMS (NLMS)
                Px = shiftReg_x' * shiftReg_x;
                if Px / Nh > minRefPower
                    h_update = h_update / (Px + chi);
                end
            end

            h_coeff = h_coeff + h_update;
        end

        w(:,i) = h_coeff;

        yOut(i) = err;

        i = i + 1;
    end

    w = transpose(w);
end
