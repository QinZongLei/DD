//
//  BGGMainBaseView.m
//  BGGSDK
//
//  Created by lisheng on 2021/5/25.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGMainBaseView.h"
#import "Masonry.h"
#import "BGGDataModel.h"
#import "BGGAPI.h"
#import "BGGPCH.h"
#import "BGGBackButton.h"
#import "BGGCloseButton.h"
#import "IQKeyboardManager.h"
#define KTitleHeight 55
@implementation BGGMainBaseView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
       if (self) {
           
           self.backgroundColor = [UIColor whiteColor];
           self.layer.cornerRadius = BGGCornerRadius;
           _titView = [[UIView alloc] initWithFrame:CGRectZero];
             [self addSubview:self.titView];
            [_titView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.top.equalTo(self.mas_top);
                make.height.equalTo(@50);
                make.right.equalTo(self.mas_right);
            }];
            _titView.backgroundColor = Color_hex(@"#FFFFFF");
            _titView.layer.cornerRadius = 12;
            _titlabel = [[UILabel alloc] init];
            _titlabel.textAlignment = NSTextAlignmentCenter;
            _titlabel.font = [UIFont systemFontOfSize:18];
            _titlabel.textColor = RGB(0, 0, 0);
            [_titView addSubview:_titlabel];
            [_titlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_titView.mas_centerX);
                make.centerY.equalTo(_titView.mas_centerY).offset(4);
            }];
            

           BGGBackButton *back = [[BGGBackButton alloc] init];
           [back setFrame:CGRectMake(0, 0, 50, 50)];
           [back setStyle:kNEWXLS_BackButtonStyleGray];
          // back.backgroundColor = BGGBlackColor;
           [back addTarget:self action:@selector(doback:) forControlEvents:UIControlEventTouchUpInside];
           [self addSubview:back];
           [back mas_makeConstraints:^(MASConstraintMaker *make) {
               make.width.height.equalTo(@50);
               make.left.equalTo(self.titView.mas_left).offset(0);
               make.top.equalTo(self.titView.mas_top).offset(0);
           }];
           self.leftButton = back;
           
           BGGCloseButton *close = [[BGGCloseButton alloc] init];
           //close.backgroundColor = BGGBlackColor;
           [close setupStyle:BGGLightGrayColor];
           [close addTarget:self action:@selector(rightbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
           [self.titView addSubview:close];
           [close mas_makeConstraints:^(MASConstraintMaker *make) {
               make.width.height.equalTo(@50);
               make.right.equalTo(self.titView.mas_right).offset(0);
               make.top.equalTo(self.titView.mas_top).offset(0);
           }];
           self.rightButton.backgroundColor =BGGredColor;
           self.rightButton = close;
           
            
            [self.titView addSubview:self.logoImageView];
            [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.titView.mas_centerX);
                make.centerY.equalTo(self.titView.mas_centerY).offset(18);
                make.width.equalTo(@150);
                make.height.equalTo(@50);
            }];
           

           UIView *maskview = [[UIView alloc] init];
           maskview.backgroundColor = [UIColor whiteColor];
           self.maskview = maskview;
       }
       return self;
}





- (void)doback:(UIButton *)sender
{
    if (self.gobackClickedBlock) {
        self.gobackClickedBlock(self, sender);
    }
    if ([BGGDataModel sharedInstance].viewArray.count == 1) {
        [self dismiss];
        return;
    }
    [self popView];
    
}

- (void)rightbuttonClick:(UIButton *)sender
{
    if (self.rightBtnClickBlock) {
        self.rightBtnClickBlock(self, sender);
    }
    [self dismiss];
    
   
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titlabel.text = title;
    //self.iconImage.hidden = YES;
    _titlabel.hidden = NO;
    _leftButton.hidden = NO;
}


- (void)addActivityIndicatorToView:(UIView *)toView frame:(CGRect)frame
{
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    [toView addSubview:self.activityIndicator];
    //设置小菊花的frame
    self.activityIndicator.frame= frame;
    //设置小菊花颜色
    //    self.activityIndicator.color = [UIColor redColor];
    //设置背景颜色
    //    self.activityIndicator.backgroundColor = [UIColor cyanColor];
    //刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
    //    self.activityIndicator.hidesWhenStopped = NO;
    [self.activityIndicator startAnimating];
}

- (void)stopActivityIndicator{
    [self.activityIndicator stopAnimating];
    self.activityIndicator = nil;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)pushToRootView:(BGGMainBaseView *)toView currentView:(BGGMainBaseView *)currentView{
    if (toView == nil) {
        return ;
    }
   // [_viewArray removeAllObjects];
    [self pushToView:toView currentView:currentView];
}


- (void)pushToView:(BGGMainBaseView *)toView currentView:(BGGMainBaseView *)currentView;
{
    
    

   CGRect toframe = toView.frame;
       CGRect currentframe = currentView.frame;
       
       if (toView == nil) return ;
       toView.hidden = NO;
       [[BGGDataModel sharedInstance].viewArray addObject:toView];
       
       [currentView addSubview:currentView.maskview];
       [toView addSubview:toView.maskview];
       toView.maskview.alpha = 1;
       currentView.maskview.alpha = 1;
       
       [UIView animateWithDuration:SYPopAnimationTIME animations:^{
           currentView.frame = toframe;
           currentView.alpha = 1;
           toView.maskview.alpha = 0;
       
           [[BGGDataModel sharedInstance].popupController.popupView addSubview:toView];
       } completion:^(BOOL finished) {
           if ([[BGGDataModel sharedInstance].popupController.popupView.subviews containsObject:currentView]) {
        
               currentView.frame = currentframe;
               
               toView.maskview.alpha = 0;
               currentView.maskview.alpha = 0;
               
               currentView.hidden = YES;
           }
       }];
    

}

- (void)popView{
    if ([BGGDataModel sharedInstance].viewArray.count < 2) {
        [self dismiss];
        return ;
    }
    NSInteger count = [BGGDataModel sharedInstance].viewArray.count;
    UIView *lastView = [[BGGDataModel sharedInstance].viewArray lastObject];
    UIView *toView = [BGGDataModel sharedInstance].viewArray[count - 2];
    toView.hidden = NO;
    [lastView removeFromSuperview];
    [[BGGDataModel sharedInstance].viewArray removeLastObject];
}

- (void)popToRootView
{
    if ([BGGDataModel sharedInstance].viewArray.count <= 2) {
        [self popView];
        return ;
    }
    UIView *lastView = [[BGGDataModel sharedInstance].viewArray lastObject];
    UIView *toView = [BGGDataModel sharedInstance].viewArray[0];
    toView.hidden = NO;
    [lastView removeFromSuperview];
    [[BGGDataModel sharedInstance].viewArray removeAllObjects];
    [[BGGDataModel sharedInstance].viewArray addObject:toView];
}
- (void)dismiss
{

    [self removeFromSuperview];
    [[BGGAPI sharedAPIManeger] BGGDismiss];
    [BGGAPI sharedAPIManeger].hideDragBtn = ![BGGDataModel sharedInstance].isLogin;
    
  
    
}



- (CGPoint)getPopControllerCenter{
    CGPoint point = CGPointMake([BGGDataModel sharedInstance].popupController.popupView.frame.size.width/2.0, [BGGDataModel sharedInstance].popupController.popupView.frame.size.height/2.0);
    return point;
}

-(UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _logoImageView.image = [UIImage BGGGetImage:@"MRDBgLgo"];
    }
    return _logoImageView;
}

@end
