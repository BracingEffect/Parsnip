#import <UIKit/UIKit.h>


@interface BECameraView : UIView

@property (nonatomic, readonly) BOOL torchEnabled;
@property (nonatomic, readonly) BOOL flashEnabled;

- (void)startVideo;
- (void)stopVideo;
- (void)pauseVideo;
- (void)resumeVideo;
- (void)captureImage:(void(^)(UIImage *image))imageHandler;

@end