//
//  UIViewController+Tools.h
//
//  Copyright (c) 2015 Bracing Effect, LLC. See LICENSE for details.
//

#import <UIKit/UIKit.h>


@interface UIViewController (Tools)

@property (nonatomic) BOOL manuallyAdjustsViewInsets;
@property (nonatomic, readonly) CGFloat statusBarHeight;
@property (nonatomic, readonly) CGRect boundsForView;
@property (nonatomic, readonly) CGRect frameForView;
@property (nonatomic, readonly) UIEdgeInsets insetsForView;
@property (nonatomic, readonly) UIScrollView *topScrollView;

- (void)setRightBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated;

- (CGRect)boundsForViewStatusBarHidden:(BOOL)statusBarHidden;
- (CGRect)boundsForViewNavigationBarHidden:(BOOL)navigationBarHidden statusBarHidden:(BOOL)statusBarHidden;
- (CGRect)frameForViewStatusBarHidden:(BOOL)statusBarHidden;
- (CGRect)frameForViewNavigationBarHidden:(BOOL)navigationBarHidden statusBarHidden:(BOOL)statusBarHidden;
- (UIEdgeInsets)insetsForViewStatusBarHidden:(BOOL)statusBarHidden;
- (UIEdgeInsets)insetsForViewNavigationBarHidden:(BOOL)navigationBarHidden statusBarHidden:(BOOL)statusBarHidden;

@end
