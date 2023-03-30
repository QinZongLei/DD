//
//  SimpleSDK_BaseView.h
//  SimpleSDK
//
//  Created by mac on 2021/12/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SimpleSDK_BaseView : UIView

@property (nonatomic, strong) UIView *view;
@property(nonatomic,strong)UIImageView *iv_viewBg;
@property(nonatomic,strong) UIImageView *iv_line;
@property(nonatomic,strong) UILabel *lb_title;
@property(nonatomic,copy) NSString *titleStr;

@property(nonatomic,copy) NSString *bgImgVStr;
@end

NS_ASSUME_NONNULL_END
