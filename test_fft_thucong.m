

%% 1. ??c ?nh và hi?n th? ?nh g?c
img = imread('k.jpg');
figure;
imshow(img);
title('Anh goc');

%% 2. Chuy?n sang ?nh xám
img = rgb2gray(img);  
figure;
imshow(img);
title('Anh xam');

%% 3. Padding ?nh ?? có kích th??c 2^n g?n nh?t
[M, N] = size(img);
M2 = 2^nextpow2(M);
N2 = 2^nextpow2(N);
padded = zeros(M2, N2);
padded(1:M, 1:N) = img;

%% 4. Bi?n ??i FFT2
F = fft2(padded);
F=fftshift(F);
  
%% 5. T?o b? l?c thông th?p Gaussian
H=zeros(M2,N2);
uo=M2/2;
vo=N2/2;
Do=50;
for u=1:M2
    for v=1:N2
        D=sqrt((u-uo)^2+(v-vo)^2);
H(u,v)=exp(-D^2/(2*Do^2));
    end
end
figure;
imshow(H);
title('Bo loc thong thap');

%% 6. Áp d?ng m?t n? l?c vào ph? ?nh
F_filtered = F .* H;
S = log(1 + abs(F_filtered));        % L?y log-magnitude ?? hi?n th? t?t h?n
imshow(S, []); 
%% 7. Bi?n ??i ng??c v? ?nh không gian
F_filtered=fftshift(F_filtered);
img_filtered = real(ifft2(F_filtered));

%% 8. C?t ?nh v? kích th??c ban ??u và chuy?n ki?u d? li?u
img_filtered_crop = uint8(img_filtered(1:M, 1:N));

%% 9. Hi?n th? ?nh sau khi nén b?ng l?c t?n s?
 img = double(img);
    img_filtered_crop = double(img_filtered_crop);
    
    mse = mean((img(:) - img_filtered_crop(:)).^2);
    if mse == 0
        pnsr = Inf; 
    else
        MAX_I = 255; 
        pnsr = 10 * log10((MAX_I^2) / mse)
    end
figure;
imshow(uint8(img_filtered_crop));
title('Anh sau khi Gaussian');

%% 11. (Tu? ch?n) L?u ?nh nén ra file JPG (có nén)
imwrite(img_filtered_crop, 'anh_nen_gaussian.jpg');

