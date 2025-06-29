function F = fft2_manual(img)
    % Ki?m tra ?nh l� ma tr?n 2 chi?u
%     if ndims(img) ~= 2
%         error('Ch? h? tr? ?nh grayscale 2D.');
%     end

    % K�ch th??c ?nh
    [M, N] = size(img);

    % Ki?m tra M, N l� l?y th?a c?a 2
%     if ~isequal(M, 2^nextpow2(M)) || ~isequal(N, 2^nextpow2(N))
%         error('?nh ph?i c� k�ch th??c l� l?y th?a c?a 2. Vui l�ng zero-padding tr??c.');
%     end
% 
%     % FFT theo h�ng
    F_rows = zeros(M, N);
    for m = 1:M
        F_rows(m, :) = fft1d_cooley_tukey(img(m, :));
    end

    % FFT theo c?t
    F = zeros(M, N);
    for n = 1:N
        F(:, n) = fft1d_cooley_tukey(F_rows(:, n).');  % chuy?n th�nh h�ng ?? x? l�
    end
end
