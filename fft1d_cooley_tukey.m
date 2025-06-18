function FT = fft1d_cooley_tukey(x)
    N = length(x);

    if  N<= 1
        FT = x;
        return;
    end

    if mod(N, 2) ~= 0
        error('Chi?u dài tín hi?u ph?i là l?y th?a c?a 2');
    end
   x_c = x(1:2:end);  % ph?n t? ch?n
    x_l = x(2:2:end);  % ph?n t? l?
    
    E = fft1d_cooley_tukey(x_c);
    O  = fft1d_cooley_tukey(x_l);

    % K?t h?p
    FT = zeros(1, N);
    for k = 0:N/2-1
        twiddle = exp(-2*pi*1i*k/N) * O(k+1);
        FT(k+1) = E(k+1) + twiddle;
        FT(k+1+N/2) = E(k+1) - twiddle;
    end
end
