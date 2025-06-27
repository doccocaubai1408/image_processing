clc; clear;

% === Kh?i t?o webcam an toàn ===
try
    cam = webcam;
catch
    error('Không the khoi dong webcam. Hãy kiem tra thiet bi.');
end

pause(1);  % Cho webcam ?n ??nh

% === Tham s? ?i?u ch?nh ===
keep_ratio        = 0.2;
area_box_thresh   = 2500;
max_area_ratio    = 0.4;
avg_kernel        = fspecial('average', [17 17]);
sigma_scale       = 1.8;
update_delay      = 0.05;

gray_prev = rgb2gray(snapshot(cam));
gray_prev = imresize(gray_prev, [256 256]);

% === T?o figure v?i handle rõ ràng ===
hFig = figure('Name', 'FFT Motion Detection (Giam nhay thong minh)')

try
    while ishandle(hFig)
        loop_start = tic;

        % === Ch?p ?nh và ti?n x? lý ===
        gray_now = rgb2gray(snapshot(cam));
        gray_now = imresize(gray_now, [256 256]);

        % === FFT và l?c Gaussian ===
        F_prev = fftshift(fft2(double(gray_prev)));
        F_now  = fftshift(fft2(double(gray_now)));

        [M, N] = size(F_prev);
        cx = round(M/2); cy = round(N/2);
        [u, v] = meshgrid(1:N, 1:M);
        D = sqrt((u - cx).^2 + (v - cy).^2);
        sigma = min(M,N) * keep_ratio / sigma_scale;
        H = exp(-(D.^2) / (2 * sigma^2));

        I_prev_nen = real(ifft2(ifftshift(F_prev .* H)));
        I_now_nen  = real(ifft2(ifftshift(F_now  .* H)));

        h = fspecial('gaussian', [5 5], 1);
        I_prev_nen = imfilter(I_prev_nen, h, 'replicate') - mean2(I_prev_nen);
        I_now_nen  = imfilter(I_now_nen,  h, 'replicate') - mean2(I_now_nen);

        I1_avg = imfilter(I_prev_nen, avg_kernel, 'replicate');
        I2_avg = imfilter(I_now_nen,  avg_kernel, 'replicate');
        diff = abs(I2_avg - I1_avg);
        diff_norm = mat2gray(diff);

        level = graythresh(diff_norm);
        mask_diff = diff_norm > level;
        mask_diff = bwareaopen(mask_diff, 100);
        mask_diff = imclose(mask_diff, strel('disk', 3));
        mask_diff = imdilate(mask_diff, strel('disk', 2));

        edge_prev = edge(I_prev_nen, 'sobel');
        edge_now  = edge(I_now_nen,  'sobel');
        edge_diff = xor(edge_prev, edge_now);
        mask_edge = imdilate(edge_diff, strel('disk', 1));
        mask_edge = bwareaopen(mask_edge, 50);

        final_mask = mask_diff & mask_edge;

        stats_all = regionprops(final_mask, 'BoundingBox');
        total_area = sum(arrayfun(@(s) s.BoundingBox(3)*s.BoundingBox(4), stats_all));
        if total_area > max_area_ratio * M * N
            final_mask(:) = 0;
        end

        subplot(1,2,1);
        imshow(gray_now); title('?nh g?c');

        subplot(1,2,2);
        imshow(mat2gray(I_now_nen));
        title('?nh nén + phát hi?n chuy?n ??ng'); hold on;

        stats = regionprops(final_mask, 'BoundingBox', 'PixelIdxList');
       
        for i = 1:length(stats)
            bb = stats(i).BoundingBox;
            p=stats(i).PixelIdxList;
            pixels = I2_avg(p);
            if bb(3)*bb(4) > area_box_thresh && std(pixels) > 0.025
                rectangle('Position', bb, 'EdgeColor', 'b', 'LineWidth', 2);
             
              
            end
        end

        hold off;
        drawnow;

      
            gray_prev = gray_now;
       

        t_elapsed = toc(loop_start);
        pause(max(0, update_delay - t_elapsed));  % Ràng bu?c th?i gian vòng l?p
    end

catch ME
    warning('?ã x?y ra l?i: %s', ME.message);
end

% === ??m b?o gi?i phóng webcam sau khi thoát vòng l?p ===
if exist('cam', 'var')
    clear cam;
    disp('Webcam ?ã t?t.');
end
