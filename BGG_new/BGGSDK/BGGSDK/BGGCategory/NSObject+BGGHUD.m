//
//  NSObject+BGGHUD.m
//  BGGSDK
//
//  Created by lisheng on 2021/5/26.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "NSObject+BGGHUD.h"
#import "SVProgressHUD.h"
#import "BGGDataModel.h"
#import "BGGSMRZView.h"
#import "BGGPCH.h"



@implementation NSObject (BGGHUD)
-(void)popNotice:(NSString *)notice{
    [self hideNotice];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setCornerRadius:5];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    if (notice) {
        [SVProgressHUD  showInfoWithStatus:notice];
    }else{
        [SVProgressHUD show];
    }
    [SVProgressHUD dismissWithDelay:2];
}
-(void)popNotice:(NSString *)notice afterTime:(NSInteger )time{
    [self hideNotice];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setCornerRadius:5];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    if (notice) {
        [SVProgressHUD  showInfoWithStatus:notice];
    }else{
        [SVProgressHUD show];
    }
    [SVProgressHUD dismissWithDelay:time];
}
-(void)popLoadingView:(NSString *)hint{
    [self hideNotice];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setCornerRadius:5];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    //禁止输入
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    // 加载中的提示框一般不要不自动dismiss，比如在网络请求，要在网络请求成功后调用 hideLoadingHUD 方法即可
    if ([hint length]) {
        [SVProgressHUD showWithStatus:hint];

    }else{
        [SVProgressHUD show];

    }
}

-(void)popLoadingView:(NSString *)hint afterTime:(NSInteger )time{
    [self hideNotice];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setCornerRadius:5];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    //禁止输入
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    // 加载中的提示框一般不要不自动dismiss，比如在网络请求，要在网络请求成功后调用 hideLoadingHUD 方法即可
    if ([hint length]) {
        [SVProgressHUD showWithStatus:hint];

    }else{
        [SVProgressHUD show];

    }
    [SVProgressHUD dismissWithDelay:time];
}


//-(void)popLoadingMaskView:(NSString *)hint{
//    [self hideNotice];
//    [SVProgressHUD showWithStatus:@"加载中请稍后" maskType:SVProgressHUDMaskTypeBlack];
//}


- (void)hideNotice{
      [SVProgressHUD dismiss];
}

-(void)BGGPresentView:(UIView *)endView{
    endView.hidden = NO;
    [[BGGDataModel sharedInstance].viewArray addObject:endView];
      endView.center = [self getPopControllerCenter];
      SYPopupController *popupController =  [SYPopupController popupControllerWithMaskType:syPopupMaskTypeBlackBlur];
      popupController.layoutType = syPopupLayoutTypeCenter;
      [popupController presentContentView:endView duration:0.25 springAnimated:NO];
      popupController.dismissOnMaskTouched = NO;
      popupController.popupView.backgroundColor = [UIColor clearColor];
      [BGGDataModel sharedInstance].popupController = popupController;
}
- (CGPoint)getPopControllerCenter{
    CGPoint point = CGPointMake([BGGDataModel sharedInstance].popupController.popupView.frame.size.width/2.0, [BGGDataModel sharedInstance].popupController.popupView.frame.size.height/2.0);
    return point;
}

-(BOOL)isFirstLoginToday{
    NSDate *senddate=[NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: senddate];
    NSDate *localDate = [senddate dateByAddingTimeInterval: interval];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *locationString=[dateformatter stringFromDate:localDate];
    if ([locationString isEqualToString:[BGGDataModel sharedInstance].todayDate]) {
        
        return NO;
    }else{
        [BGGDataModel sharedInstance].todayDate = locationString;
        
        return YES;
    }
    
    
    
    
   
    
}
@end
