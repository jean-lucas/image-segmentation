# image-segmentation
Segments an image and saves each segment into a separate image. Uses a minimal bounding box evaluation.

**Requires Matlab's Image Processing Toolbox**

Meant to segment images containing *simple* handwritten mathematical expressions. May not work as expected if symbols are touching.


Sample Call: 
```matlab
segment_img('test.png',32,32) % make output 32px wide by 32px high
``` 

Return Value: 
```matlab
["char_1.png", "char_2.png", "char_3.png", "char_4.png", "char_5.png", "char_6.png", "char_7.png"]
```




Input image: <br>
<img src="https://github.com/jean-lucas/image-segmentation/blob/master/test.png" alt="input image" width="300"/>


Output: <br>
<img src="https://github.com/jean-lucas/image-segmentation/blob/master/out/char_1.png" alt="input image" width="30"/>, 
<img src="https://github.com/jean-lucas/image-segmentation/blob/master/out/char_2.png" alt="input image" width="30"/>,
<img src="https://github.com/jean-lucas/image-segmentation/blob/master/out/char_3.png" alt="input image" width="30"/>,
<img src="https://github.com/jean-lucas/image-segmentation/blob/master/out/char_4.png" alt="input image" width="30"/>,
<img src="https://github.com/jean-lucas/image-segmentation/blob/master/out/char_5.png" alt="input image" width="30"/>,
<img src="https://github.com/jean-lucas/image-segmentation/blob/master/out/char_6.png" alt="input image" width="30"/>,
<img src="https://github.com/jean-lucas/image-segmentation/blob/master/out/char_7.png" alt="input image" width="30"/> <br>


