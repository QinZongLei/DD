//
//  SimpleSDK_CustomUITextFieldView.h
//  SimpleSDK
//
//  Created by mac on 2021/12/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SimpleSDK_CustomUITextFieldView : UIView

@property(nonatomic,strong)UIImageView *iv_viewBg;

@property(nonatomic,strong)UIImageView *iv_leftIcon;

@property(nonatomic,strong)UITextField *tf_input;

@property(nonatomic,strong)UILabel *tf_leftLb;

@property(nonatomic,strong)UIButton *btn_right;

@property(nonatomic,copy) UIImage *iconPath;

@property(nonatomic,copy) NSString *placeholderStr;

@property(nonatomic,copy) NSString *leftTitleLbStr;

@end

NS_ASSUME_NONNULL_END
