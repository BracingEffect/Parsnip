#import "UIImage+OpenCV.h"

#import "UIImage+Manipulation.h"


static inline void premultiplyImage(IplImage *img, BOOL reverse);
static void releaseImage(void *info, const void *data, size_t size);


@implementation UIImage (OpenCV)

static inline void premultiplyImage(IplImage *img, BOOL reverse)
{
    //NSAssert(img->depth == IPL_DEPTH_8U, "depth not IPL_DEPTH_8U");
    uchar *row = (uchar *)img->imageData;
    
    for (int i = 0; i < img->height; i++) {
        for (int j = 0; j < img->width; j+= img->nChannels) {
            uchar alpha = row[j + 3];
            if (alpha != UCHAR_MAX && (!reverse || alpha != 0)) {
                for (int k = 0; k < 3; k++) {
                    if (reverse) {
                        row[j + k] = ((int)row[j + k] * UCHAR_MAX + alpha / 2 - 1) / alpha;
                    } else {
                        row[j + k] = ((int)row[j + k] * alpha + UCHAR_MAX / 2 - 1) / UCHAR_MAX;
                    }
                }
            }
        }
        row += img->widthStep;
    }
}

static void releaseImage(void *info, const void *data, size_t size)
{
    IplImage *image = (IplImage *)info;
    cvReleaseImage(&image);
}

- (cv::Mat)mat
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(self.CGImage);
    CGFloat cols = self.size.width;
    CGFloat rows = self.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), self.CGImage);
    CGContextRelease(contextRef);

    return cvMat;
}

- (cv::Mat)matGray
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(self.CGImage);
    CGFloat cols = self.size.width;
    CGFloat rows = self.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), self.CGImage);
    CGContextRelease(contextRef);

    return cvMat;
}

//- (UIImage *)binarization
//{
//    IplImage *iplImage = [self iplImageWithNumberOfChannels:3];
//    IplImage *binaryIplImage = createBinarizedImage(iplImage, 85.0, 255.0, 3);
////    IplImage *binaryIplImage = createBinarizedImage(iplImage);
//    cvReleaseImage(&iplImage);
//    UIImage *image = [UIImage imageFromIplImage:binaryIplImage];
//    cvReleaseImage(&binaryIplImage);
//    return image;
//}

/**
 * Must call cvReleaseImage(iplImage) and free(iplImage) on returned (IplImage *).
 */
- (IplImage *)iplImageWithNumberOfChannels:(int)channels
{
    NSAssert(channels == 1 || channels == 3 || channels == 4, @"Invalid number of channels");
    
    CGImageRef cgImage = [self CGImage];
    BOOL drawTransposed;
    CGAffineTransform transform = [self transformForOrientationDrawnTransposed:&drawTransposed];
    
    CvSize cvsize = cvSize(drawTransposed ? CGImageGetHeight(cgImage) : CGImageGetWidth(cgImage),
                           drawTransposed ? CGImageGetWidth(cgImage) : CGImageGetHeight(cgImage));
    IplImage *iplImage = cvCreateImage(cvsize, IPL_DEPTH_8U, (channels == 3) ? 4 : channels);       // CG can only write into 4 byte aligned bitmaps
    
    CGBitmapInfo bitmapInfo = kCGImageAlphaNone;
    if (channels == 3) {
        bitmapInfo = kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little;        // BGRX. CV_BGRA2BGR will discard the uninitialized alpha channel data.
    } else if (channels == 4) {
        bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little;   // BGRA. Must unpremultiply the image.
    }
    
    CGColorSpaceRef colorSpace = (channels == 1) ? CGColorSpaceCreateDeviceGray() : CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(iplImage->imageData,
                                                       iplImage->width,
                                                       iplImage->height,
                                                       iplImage->depth,
                                                       iplImage->widthStep,
                                                       colorSpace,
                                                       bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmapContext, transform);
    
    // Copy the source bitmap into the destination, ignoring any data in the uninitialized destination
    CGContextSetBlendMode(bitmapContext, kCGBlendModeCopy);
    
    // Drawing CGImage to CGContext
    CGRect rect = CGRectMake(0.0, 0.0, CGImageGetWidth(cgImage), CGImageGetHeight(cgImage));
    CGContextDrawImage(bitmapContext, rect, cgImage);
    CGContextRelease(bitmapContext);
    
    // Unpremultiply the alpha channel if the source image had one (since otherwise the alphas are 1)
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(cgImage);
    if (channels == 4 && (alphaInfo != kCGImageAlphaNone && alphaInfo != kCGImageAlphaNoneSkipFirst && alphaInfo != kCGImageAlphaNoneSkipLast)) {
        premultiplyImage(iplImage, YES);
    }
    
    // Convert BGRA images to BGR
    if (channels == 3) {
        IplImage *temp = cvCreateImage(cvGetSize(iplImage), IPL_DEPTH_8U, channels);
        cvCvtColor(iplImage, temp, CV_BGRA2BGR);
        cvReleaseImage(&iplImage);
        iplImage = temp;
    }
    
    return iplImage;
}

+ (UIImage *)imageFromIplImage:(IplImage *)iplImage
{
    return [UIImage imageFromIplImage:iplImage orientation:UIImageOrientationUp];
}

+ (UIImage *)imageFromIplImage:(IplImage *)iplImage orientation:(UIImageOrientation)orientation
{
    // CGImage requries either 8-bit or 32-bit aligned images
    IplImage *formattedImage;
    if (iplImage->nChannels == 3) {
        formattedImage = cvCreateImage(cvGetSize(iplImage), IPL_DEPTH_8U, 4);
        cvCvtColor(iplImage, formattedImage, CV_BGR2BGRA);
    } else if (iplImage->nChannels == 4) {
        
        formattedImage = cvCloneImage(iplImage);
    
        premultiplyImage(formattedImage, NO);
    } else {
        formattedImage = cvCloneImage(iplImage);
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(formattedImage, formattedImage->imageData, formattedImage->imageSize, releaseImage);
    
    CGBitmapInfo bitmapInfo = (iplImage->nChannels == 1) ? kCGImageAlphaNone : (kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);    
    CGColorSpaceRef colorSpace = (formattedImage->nChannels == 1) ? CGColorSpaceCreateDeviceGray() : CGColorSpaceCreateDeviceRGB();    
    CGImageRef cgImage = CGImageCreate(formattedImage->width,
                                       formattedImage->height,
                                       formattedImage->depth,
                                       formattedImage->depth * formattedImage->nChannels,
                                       formattedImage->widthStep,
                                       colorSpace,
                                       bitmapInfo,
                                       provider,
                                       NULL,
                                       false,
                                       kCGRenderingIntentDefault);
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(provider);
    
    UIImage *image = [UIImage imageWithCGImage:cgImage scale:1.0 orientation:orientation];
    CGImageRelease(cgImage);
    
    return image;
}

//- (NSArray *)textBoundingBoxes
//{
//    DetectText detectText;
//    cv::Mat mat = [self mat];
//    vector<cv::Rect> boundingBoxes = detectText.getBoundingBoxes(mat);
//    NSMutableArray *boxes = [NSMutableArray arrayWithCapacity:boundingBoxes.size()];
//	std::for_each(boundingBoxes.begin(), boundingBoxes.end(), ^(cv::Rect r) {
//		[boxes addObject:[NSValue valueWithCGRect:CGRectMake(r.x, r.y, r.width, r.height)]];
//	});
//	NSLog(@"%@", boxes);
//    return boxes;
//}

+ (UIImage *)imageFromMat:(cv::Mat)mat
{
    NSData *data = [NSData dataWithBytes:mat.data length:mat.elemSize()*mat.total()];
    CGColorSpaceRef colorSpace;
    
    if (mat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(mat.cols,                                    //width
                                        mat.rows,                                    //height
                                        8,                                           //bits per component
                                        8 * mat.elemSize(),                          //bits per pixel
                                        mat.step[0],                                 //bytesPerRow
                                        colorSpace,                                  //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault, //bitmap info
                                        provider,                                    //CGDataProviderRef
                                        NULL,                                        //decode
                                        false,                                       //should interpolate
                                        kCGRenderingIntentDefault);                  //intent
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

- (CGAffineTransform)transformForOrientationDrawnTransposed:(BOOL *)drawTransposed
{
    UIImageOrientation imageOrientation = [self imageOrientation];
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGSize size = [self size];  // already transposed by UIImage
    
    switch (imageOrientation) {
        case UIImageOrientationDown:           // EXIF orientation 3
        case UIImageOrientationDownMirrored:   // EXIF orientation 4
            transform = CGAffineTransformTranslate(transform, size.width, size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF orientation 6
        case UIImageOrientationLeftMirrored:   // EXIF orientation 5
            transform = CGAffineTransformTranslate(transform, size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF orientation 8
        case UIImageOrientationRightMirrored:  // EXIF orientation 7
            transform = CGAffineTransformTranslate(transform, 0, size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF orientation 2
        case UIImageOrientationDownMirrored:   // EXIF orientation 4
            transform = CGAffineTransformTranslate(transform, size.width, 0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF orientation 5
        case UIImageOrientationRightMirrored:  // EXIF orientation 7
            transform = CGAffineTransformTranslate(transform, size.height, 0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        default:
            break;
    }
    
    if (drawTransposed) {
        switch (imageOrientation) {
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                *drawTransposed = YES;
                break;
                
            default:
                *drawTransposed = NO;
        }
    }
    
    return transform;
}

@end
