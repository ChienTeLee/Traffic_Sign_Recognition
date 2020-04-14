% Traffic Sign Recognition

% Threshold red and blue colors in HSV color space to create region crops.
% Extract HOG features in region crops.
% Use HOG features to train an SVM model and recognize traffic signs

clear;
close all;
clc;

foldername = {'00045', '00021', '00038', '00035', '00017', '00001', '00014', '00019'};
nFolder = size(foldername,2);

hogCellSize = [16 16];

% prepare training set
mkdir ./sample
for i = 1 : nFolder
    file = dir(fullfile('./dataset/TSR/Training/', char(foldername(i)), '/', '*.ppm'));
    filename = {file.name};
    nFile = size(filename, 2);
    
    classLabel = (i-1)*ones(1, 1);
    
    for j = 1 : nFile
        rawImg = imread(fullfile('./dataset/TSR/Training', char(foldername(i)), '/', char(filename(j))));
        resizedImg = imresize(rawImg, [64 64]);
        grayImg = rgb2gray(resizedImg);
        denoisedImg = medfilt2(grayImg);
        histeqImg = histeq(denoisedImg);
        [featureVector, hogVisualization] = extractHOGFeatures(histeqImg, 'CellSize', hogCellSize);
        
        if i==1 && j ==1
            trainData = featureVector;
            trainLabel = classLabel;
        else
            trainData = vertcat(trainData, featureVector);
            trainLabel = vertcat(trainLabel, classLabel);
        end
        
        if j == 16
            % save resized image as display sample
            img_name = join([char(foldername(i)), '_sample.png']);
            samplePath = fullfile('./sample', img_name);
            imwrite(resizedImg, samplePath);
        end
    end
end

% create SVM training model
SVMModel = fitcecoc(trainData, trainLabel);


disp('Begin Creating Video');

mkdir ./output
writer = VideoWriter('./output/output_video.mp4');
writer.FrameRate = 35;
open(writer);

% input image
file = dir('./dataset/TSR/input/*.jpg');
filename = {file.name};
nImage = size(filename, 2);


for i = 1 : nImage
    rawImg = imread(fullfile('./dataset/TSR/input/', char(filename(i))) );
    %figure;
    %imshow(rawImg);
    hsvImg = rgb2hsv(rawImg);
    H = hsvImg(:,:,1);
    S = hsvImg(:,:,2);
    V = hsvImg(:,:,3);
    
    % threshold red and blue color in HSV color space
    % threshold red color
    maskR =  ((H<0.025) | (H>0.96)) ;
    maskR =  maskR & (S>0.2) & (S<0.8);
    maskR = maskR & (V>0.3);
    maskR = bwareafilt(maskR, [200, 3000]);
    maskR = imfill(maskR, 'holes');
    % threshold blue color
    maskB = (0.56<H) & (H<0.61);
    maskB =  maskB & (S>0.2);
    maskB = maskB & (V>0.3);
    maskB = bwareafilt(maskB, [400, 8000]);
    maskB = imfill(maskB, 'holes');
    
    mask = maskR | maskB;
    %figure;
    %imshow(mask);
    
    stats = regionprops(mask, 'BoundingBox');
    
    for j = 1 : length(stats)
        boundBox = stats(j).BoundingBox;
        % limit weidth / length
        scale = boundBox(3) / boundBox(4);
        
        if scale > 0.4 && scale < 2.5
            cropImg = imcrop(rawImg, boundBox);
            resizedImg = imresize(cropImg, [64 64]);
            grayImg = rgb2gray(resizedImg);
            denoisedImg = medfilt2(grayImg);
            histeqImg = histeq(denoisedImg);
            
            featureVector = extractHOGFeatures(histeqImg, 'CellSize', hogCellSize);
            
            [label, score, cost] = predict(SVMModel, featureVector);
            [Max, Idx] = max(score);
            
            % insert bounding box and traffic sign sample in raw image
            if (Max > -0.01) % threshold score
                rawImg = insertShape(rawImg, 'Rectangle', boundBox, 'Color', 'y', 'LineWidth',1); % draw boundbox
                img_name = join([char(foldername(Idx)), '_sample.png']);
                sampleImg = imread(fullfile('./sample', img_name));
                boundBoxX = floor(boundBox(1));
                boundBoxY = floor(boundBox(2));
                if (boundBoxX+63<1629 && boundBoxY-63>0)
                    rawImg(boundBoxY-63:boundBoxY, boundBoxX:boundBoxX+63, :) = sampleImg; % insert sample
                end
                
            end
             
        end
    end
    %figure;
    %imshow(rawImg);
    writeVideo(writer, rawImg);
    disp(['processing image', num2str(i)]);
end

close(writer);

disp('Finish Creating Video');

