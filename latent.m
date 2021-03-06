I = im2double(imread('latent.bmp'));
I = histeq(I);
[M1, N1] = size(I);

%% Preprocess
% (only used to calculate orientation
w = 16;
block_x = (0 : floor((M1-w)/w) ) * w + 1; % separating into blocks
block_y = (0 : floor((N1-w)/w) ) * w + 1;
J = I;
for i = 1 : length(block_x)
    for j = 1 : length(block_y)
        u = block_x(i); v = block_y(j);
        block_region = I(u:(u+w-1), v:(v+w-1));
        J(u:(u+w-1), v:(v+w-1)) = imbinarize(block_region, thresh);
    end
end
imshow(J)

%% Enhance
w = 32;
O = localOrientation(J, w);
F = localFrequency(J, w);

vthresh1 = 3;
vthresh2 = 2;
fthresh = 0.4;
expand = 0;

fingerprint = extractFingerprint(J, O, F, w, vthresh1, vthresh2, fthresh, 0);
result = spatialGabor(I, fingerprint, O, F, w);

figure;
% subplot(1,3,1); imshow(I);
subplot(1,2,1); plotOrientation(I, O, fingerprint, w); title('Orientation & Mask');
subplot(1,2,2); imshow(result); title('Fingerprint Enhancement');
