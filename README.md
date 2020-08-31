# Traffic Sign Recognition

## Overview
The objective of this project is to build a traffic sign recognition system to recognize traffic signs on the street. A two stage pipeline containing traffic sign detection and traffic sign classification is applied to build the system. First, we threshold red and blue color in hsv colorspace to create masks from raw images, and then we generate region crops from masks as detected traffic sign candidates. Secondly, the HOG features are extracted from region crops. Next, we use TSR training dataset to train an multiclass SVM model, and do traffic sign classification for each region crops. Finally, we plot the bounding boxes for each region crop, and show the detected traffic sign. (This project is implemented in matlab code and is only for self-practice purpose.)

## Dataset
The traffic sign recognition dataset is a video of street views in Belgium, and the sceneray contains various belgian traffic signs. It is created and maintained by Radu Timofte and ETH-Zurich Vision Lab. In this project, we focus only on the following target traffic signs.

<p align="center">
  <img src="https://github.com/ChienTeLee/traffic_sign_recognition/blob/master/doc/fig0.png" width="50%" height="50%"> 
</p> 

[TSR dataset (used by this project)](https://drive.google.com/drive/folders/0B8DbLKogb5ktTW5UeWd1ZUxibDA)

[KUL Belgium Traffic Sign dataset original website](http://people.ee.ethz.ch/~timofter/traffic_signs/index.html)

## How to run
1. Create a folder named "dataset"
2. Download [TSR dataset](https://drive.google.com/drive/folders/0B8DbLKogb5ktTW5UeWd1ZUxibDA) and put "TSR" folder in "dataset" folder
3. run TrafficSignRecognition.m.
4. After running, an output video will appear in "output" folder.

## Implementation
1. Create mask to threshold raw image for red and blue color in hsv colorspace and generate region crops.
<p align="center">
  <img src="https://github.com/ChienTeLee/traffic_sign_recognition/blob/master/doc/fig1.png" width="85%" height="85%"> 
</p> 

2. Extract HOG features from the cropped out regions. The HOG algorithm decomposes image into small cells, calcuates occurrences of gradient orientation within each cell, and then do normalization on the result.
<p align="center">
  <img src="https://github.com/ChienTeLee/traffic_sign_recognition/blob/master/doc/fig2.png" width="55%" height="55%"> 
</p>

3. Train a linear multiclass SVM model with TSR training dataset. Use the trained multiclass SVM model to do traffic sign classification for each region crops.
<p align="center">
  <img src="https://github.com/ChienTeLee/traffic_sign_recognition/blob/master/doc/fig3.png" width="35%" height="35%"> 
</p>

4. Plot bounding box for each region crop and display the detected traffic sign.
<p align="center">
  <img src="https://github.com/ChienTeLee/traffic_sign_recognition/blob/master/doc/fig4.png" width="60%" height="60%"> 
</p>

## Results
<p align="center">
  <img src="https://github.com/ChienTeLee/traffic_sign_recognition/blob/master/doc/output.gif" width="55%" height="55%"> 
</p>

full video: https://www.youtube.com/watch?v=bYXJq5i25ng

## Slides
[Slides](https://drive.google.com/file/d/1KDlHB9HNlobLCCqVCgajPeJvsHUhgJW4/view?usp=sharing)

## Reference
1. [Traffic sign recognition—how far are we from the solution?](https://ieeexplore.ieee.org/document/6707049)

2. [Histogram of oriented gradients (wikipedia)](https://en.wikipedia.org/wiki/Histogram_of_oriented_gradients)

3. [Histogram of Oriented Gradients (learnopencv)](https://www.learnopencv.com/histogram-of-oriented-gradients)

4. [Introduction to Support Vector Machines (opencv)](https://docs.opencv.org/2.4/doc/tutorials/ml/introduction_to_svm/introduction_to_svm.html)

5. [extractHOGFeatures (matlab)](https://www.mathworks.com/help/vision/ref/extracthogfeatures.html)

6. [fitcecoc (matlab)](https://www.mathworks.com/help/stats/fitcecoc.html)
