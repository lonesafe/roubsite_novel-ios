//
//  MBProgressHUD+ATAdd.m
//  Postre
//
//  Created by 王炜圣 on 2017/4/6.
//  Copyright © 2017年 王炜圣. All rights reserved.
//

#import "MBProgressHUD+ATAdd.h"


@implementation MBProgressHUD (ATAdd)
+ (UIView *)defaultView {
    UIView *view;
    for (UIWindow * window in [UIApplication sharedApplication].windows) {
        if (!window.hidden
            && (window.windowLevel < UIWindowLevelStatusBar)) {
            view = window;
        }
    }
    return view;
}
+ (UIImage *)defaultSuccessImage {
    return [UIImage imageNamed:@"mb_hud_success"];
}
+ (UIImage *)defaultFailureImage {
    return [UIImage imageNamed:@"mb_hud_failure"];
}
+ (NSTimeInterval)displayDurationForString:(NSString*)string {
    NSTimeInterval duration = (CGFloat)string.length * 0.06 + 0.5;
    return MAX(1.5f, MIN(duration, MBHudShowMaxDuration));
}


+ (MBProgressHUD *)showMessage:(NSString *)message {
    return [self showMessage:message toView:nil hideAfterDelay:[self displayDurationForString:message] completion:nil];
}
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    return [self showMessage:message toView:view hideAfterDelay:[self displayDurationForString:message] completion:nil];
}
+ (MBProgressHUD *)showWithCompletion:(void (^)(MBProgressHUD *hud))completion {
    return [self showMessage:nil toView:nil hideAfterDelay:MBHudShowMaxDuration completion:completion];
}
+ (MBProgressHUD *)showToView:(UIView *)view completion:(void (^)(MBProgressHUD *hud))completion {
    return [self showMessage:nil toView:view hideAfterDelay:MBHudShowMaxDuration completion:completion];
}
+ (MBProgressHUD *)showMessage:(NSString *)message completion:(void (^)(MBProgressHUD *hud))completion {
    return [self showMessage:message toView:nil hideAfterDelay:MBHudShowMaxDuration completion:completion];
}
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view completion:(void (^)(MBProgressHUD *hud))completion {
    return [self showMessage:message toView:view hideAfterDelay:MBHudShowMaxDuration completion:completion];
}
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay completion:(void (^)(MBProgressHUD *hud))completion {
    return [self showMessage:message toView:view graceTime:0 hideAfterDelay:delay completion:completion];
}
+ (instancetype)graceShowMessage:(NSString *)message toView:(UIView *)view completion:(void (^)(MBProgressHUD *))completion {
    return [self showMessage:message toView:view graceTime:MBHudGraceTime hideAfterDelay:MBHudShowMaxDuration completion:completion];
}
+ (MBProgressHUD *)showMessage:(NSString *)message
                        toView:(UIView *)view
                     graceTime:(NSTimeInterval)gractTime
                hideAfterDelay:(NSTimeInterval)delay
                    completion:(void (^)(MBProgressHUD *))completion
{
    if (!completion && message.length <= 0) {
        return nil;
    }
    
    view = view ?: [MBProgressHUD defaultView];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.label.text = message;
    hud.contentColor = [UIColor whiteColor];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.7];
    hud.bezelView.layer.cornerRadius = 4.0f;
    hud.removeFromSuperViewOnHide = YES;
    hud.animationType = MBProgressHUDAnimationFade;
    if (gractTime > 0) {
        hud.graceTime = gractTime;
    }
    [hud showAnimated:YES];
    if (delay) {
        [hud hideAnimated:YES afterDelay:delay];
    }
    if (completion) {
        completion(hud);
    }
    else {
        hud.mode = MBProgressHUDModeText;
        hud.margin = 10.0f;
        hud.label.numberOfLines = 0;
//        hud.offset = CGPointMake(0.0f, view.frame.size.height * 0.3f);
        hud.userInteractionEnabled = NO;
    }
    
    return hud;
}

#pragma mark - hide
+ (instancetype)hudForView:(UIView *)view {
    return [self HUDForView:(view ?: [MBProgressHUD defaultView])];
}
- (void)hideWithMessage:(NSString *)message completion:(MBProgressHUDCompletionBlock)completion {
    return [self hideWithMessage:message
                           image:nil
                        animated:YES
                           delay:MBHudHideDelay
                      completion:completion];
}
- (void)hideWithSuccess:(NSString *)message completion:(MBProgressHUDCompletionBlock)completion {
    return [self hideWithMessage:message
                           image:[MBProgressHUD defaultSuccessImage]
                        animated:YES delay:MBHudHideDelay
                      completion:completion];
}
- (void)hideWithFailure:(NSString *)message completion:(MBProgressHUDCompletionBlock)completion {
    return [self hideWithMessage:message
                           image:[MBProgressHUD defaultFailureImage]
                        animated:YES delay:MBHudHideDelay
                      completion:completion];
}
- (void)hideWithAnimated:(BOOL)animated completion:(MBProgressHUDCompletionBlock)completion {
    return [self hideWithMessage:nil
                           image:nil
                        animated:animated
                           delay:MBHudHideDelay
                      completion:completion];
}
- (void)hideWithMessage:(NSString *)message
                  image:(UIImage *)image
               animated:(BOOL)animated
                  delay:(NSTimeInterval)delay
             completion:(MBProgressHUDCompletionBlock)completion {
    if (message) {
        self.label.text = message;
    }
    if (image) {
        self.customView = [[UIImageView alloc] initWithImage:image];
    }
    self.detailsLabel.text = nil;
    self.mode = MBProgressHUDModeCustomView;
    [self setCompletionBlock:completion];
    if (message.length == 0 && image == nil) {
        [self hideAnimated:animated];
    }
    else {
        [self hideAnimated:animated afterDelay:delay];
    }
}
@end
