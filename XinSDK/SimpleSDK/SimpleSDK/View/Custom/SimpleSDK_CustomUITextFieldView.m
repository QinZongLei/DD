//
//  SimpleSDK_CustomUITextFieldView.m
//  SimpleSDK
//
//  Created by mac on 2021/12/17.
//

#import "SimpleSDK_CustomUITextFieldView.h"
#import "SImpleSDK_Tools.h"

@interface SimpleSDK_CustomUITextFieldView ()<UITextFieldDelegate>

@end

@implementation SimpleSDK_CustomUITextFieldView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self func_setCustomUITextFieldView];
    }
    return self;
}

-(void)func_setCustomUITextFieldView{
    
    [self addSubview:({
        self.tf_leftLb = [[UILabel alloc] init];
        self.tf_leftLb.textColor = color_lbTfLeftTextHex;
        self.tf_leftLb.font = [UIFont systemFontOfSize:kWidth(tfLeftLabelInpublicFont)];
        self.tf_leftLb.frame = CGRectMake(0, 0, kWidth(60), kWidth(35));
        self.tf_leftLb;
    })];
    
    [self addSubview:({
        self.iv_viewBg = [[UIImageView alloc]  init];
        self.iv_viewBg .userInteractionEnabled = YES;
        self.iv_viewBg.image = kSetBundleImage(inputBg);
        self.iv_viewBg.frame = CGRectMake(self.tf_leftLb.right+kWidth(5), 0, self.width - kWidth(65), kWidth(35));
        self.iv_viewBg;
    })];
    
    [self.iv_viewBg addSubview:({
        self.tf_input = [[UITextField alloc]  init];
        self.tf_input.textColor = color_edit_body;
        self.tf_input.frame = CGRectMake(kWidth(5), 0, self.iv_viewBg.width-kWidth(15), self.iv_viewBg.height);
        self.tf_input.font = [UIFont systemFontOfSize:kWidth(17)];
        self.tf_input.delegate = self;
        self.tf_input.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.tf_input;
    })];
    

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.tf_input) {
   
      if (range.length == 1 && string.length == 0) {
        return YES;
      }else if (self.tf_input.text.length >= 14) {
        self.tf_input.text = [textField.text substringToIndex:14];
        return NO;
      }
    }
  return YES;
}

// 大写字母转小写字母
- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.text = [textField.text lowercaseString];
}

- (void)setLeftTitleLbStr:(NSString *)leftTitleLbStr
{
    _leftTitleLbStr = leftTitleLbStr;
    
    self.tf_leftLb.text = leftTitleLbStr;
}

- (void)setIconPath:(UIImage *)iconPath{
    _iconPath = iconPath;
    if ([SimpleSDK_Tools func_judgeUIimageForNil:_iconPath]) {
        [self.iv_viewBg addSubview:({
            self.iv_leftIcon = [[UIImageView alloc] init];
            self.iv_leftIcon.image =iconPath;
            self.iv_leftIcon.frame = CGRectMake(kWidth(10), kWidth(7), kWidth(15), kWidth(15));
            self.iv_leftIcon.centerY = self.iv_viewBg.centerY;
            self.iv_leftIcon;
        })];
        
        if (_btn_right != nil) {
            //如果设置了按钮需要调整位置
            self.tf_input.frame = CGRectMake(self.iv_leftIcon.right+ kWidth(5), 0, self.iv_viewBg.width-self.iv_leftIcon.width-self.btn_right.width-kWidth(25), self.iv_viewBg.height);
            [self layoutIfNeeded];
        }else{
            //没有设置按钮不需要调整位置
            self.tf_input.frame = CGRectMake(self.iv_leftIcon.right+ kWidth(5), 0, self.iv_viewBg.width-self.iv_leftIcon.width-kWidth(15), self.iv_viewBg.height);
            [self layoutIfNeeded];
        }
    }
}

- (void)setBtn_right:(UIButton *)btn_right{
    _btn_right = btn_right;
    if (_btn_right != nil) {
        //首先判断是否开启左边icon
        if ([SimpleSDK_Tools func_judgeUIimageForNil:_iconPath]) {
            [self.iv_viewBg addSubview:_btn_right];
            self.tf_input.frame = CGRectMake(self.iv_leftIcon.right+ kWidth(5), 0, self.iv_viewBg.width-self.iv_leftIcon.width-self.btn_right.width-kWidth(25), self.iv_viewBg.height);
            [self layoutIfNeeded];
        }else{
            self.tf_input.frame = CGRectMake(kWidth(5), 0, self.iv_viewBg.width-kWidth(15), self.iv_viewBg.height);
            [self layoutIfNeeded];
        }
    }
    //如果没有按钮则无需修改
}

- (void)setPlaceholderStr:(NSString *)placeholderStr{
    if (!kStringIsNull(placeholderStr)) {
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:placeholderStr attributes:
                                                     @{NSForegroundColorAttributeName:color_edit_prompt,
        NSFontAttributeName:[UIFont systemFontOfSize:kWidth(14)]}];
            self.tf_input.attributedPlaceholder = attrString;
    }
}

@end
