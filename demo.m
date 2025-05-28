brain=imread('brain1.jpg');
imshow(brain); 
figure
brain=rgb2gray(brain);
[M N]=size(brain);
brain_process=zeros(2*M,2*N);
brain_process(1:M,1:N)=brain;
brain_fft=fft2(brain_process);
brain_fft=fftshift(brain_fft);
mesh(abs(brain_fft));
[P Q]=size(brain_process);
H=zeros(P,Q);
uo=P/2;
vo=Q/2;
Do=15;
for u=1:P
    for v=1:Q
        D=sqrt((u-uo)^2+(v-vo)^2);
H(u,v)=1-exp(-D^2/(2*Do^2));
    end
end
f_fillter=brain_fft.*H;
brain_fft=ifftshift(f_fillter);
brain_process=ifft2(real(brain_fft));
brain=brain_process(1:M,1:N);
imshow(uint8(brain));
brain_gray=uint8(brain);
edges = edge(brain_gray, 'Canny');

% Hi?n th? ?nh g?c và v? biên
imshow(brain_gray, []);
title('Biên ?nh b?ng Canny');
hold on;

% Tìm ???ng vi?n t? ?nh biên
boundaries = bwboundaries(edges);

% V? ???ng vi?n
for k = 1:length(boundaries)
    b = boundaries{k};
    plot(b(:,2), b(:,1), 'r', 'LineWidth', 1.5);  % vi?n màu ??
end
