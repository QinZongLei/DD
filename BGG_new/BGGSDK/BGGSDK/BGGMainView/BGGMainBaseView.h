//
//  BGGMainBaseView.h
//  BGGSDK
//
//  Created by lisheng on 2021/5/25.
//  Copyright © 2021 BGG. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface BGGMainBaseView : UIView
/**
 导航
 */
@property (strong,nonatomic) UIView *titView;

/**
 标题Label
 */
@property (strong,nonatomic) UILabel *titlabel;

/**
 顶部图片
 */
@property (strong,nonatomic) UIImageView *logoImageView;

/**
 导航左边按钮
 */
@property (strong,nonatomic) UIButton *leftButton;

/**
 导航右边按钮
 */
@property (weak,nonatomic) UIButton *rightButton;

/**
 蒙版试图
 */
@property (nonatomic,strong) UIView *maskview;

/**
 顶部图标
 */
@property (weak,nonatomic) UIImageView *iconImage;

/**
 标题
 */
@property (weak,nonatomic) NSString *title;

/**
 返回按钮点击回调
 */
@property (nonatomic, copy) void (^gobackClickedBlock)(BGGMainBaseView *keyboardView, UIButton *button);

/**
 右边按钮点击回调
 */
@property (nonatomic, copy) void (^rightBtnClickBlock)(BGGMainBaseView *keyboardView, UIButton *button);

/**
 菊花
 */
@property (strong,nonatomic) UIActivityIndicatorView *activityIndicator;

/**
 加菊花

 @param toView toView description
 @param frame frame description
 */
- (void)addActivityIndicatorToView:(UIView *)toView frame:(CGRect)frame;

/**
 移除菊花
 */
- (void)stopActivityIndicator;

/**
 获取页面中心点

 @return return value description
 */
- (CGPoint)getPopControllerCenter;

/**
 PUSH至根试图

 @param toView toView description
 @param currentView currentView description
 */
- (void)pushToRootView:(BGGMainBaseView *)toView currentView:(BGGMainBaseView *)currentView;

/**
 PUSH下个界面

 @param toView toView description
 @param currentView currentView description
 */
- (void)pushToView:(BGGMainBaseView *)toView currentView:(BGGMainBaseView *)currentView;

/**
 Pop返回上个界面
 */
- (void)popView;


/**
 Pop返回根界面
 */
- (void)popToRootView;

/**
 关闭界面
 */
- (void)dismiss;


/**
 导航右键点击方法

 @param sender button
 */
- (void)rightbuttonClick:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
