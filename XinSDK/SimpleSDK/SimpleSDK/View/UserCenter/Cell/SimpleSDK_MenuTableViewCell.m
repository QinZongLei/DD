//
//  SimpleSDK_MenuTableViewCell.m
//  SimpleSDK
//
//  Created by admin on 2021/12/23.
//

#import "SimpleSDK_MenuTableViewCell.h"
#import "SimpleSDK_DataTools.h"


@interface SimpleSDK_MenuTableViewCell()
@property (nonatomic, strong) UIImageView *iv_iconImage;
@property (nonatomic, strong) UILabel *lb_name;
@property (nonatomic, strong) UILabel *lb_prompt;
@property (nonatomic, strong) UIButton *btn_operation;
@end

@implementation SimpleSDK_MenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self  func_addNotification];
        [self func_setMenuTableViewCell];
    }
    return self;
}

-(void)func_addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(func_didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

-(void)func_setMenuTableViewCell{
    self.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:({
        self.iv_iconImage = [[UIImageView alloc] init];
        self.iv_iconImage.frame = CGRectMake(kWidth(25), kWidth(10), kWidth(20), kWidth(20));
        self.iv_iconImage;
    })];
    
    [self.contentView addSubview:({
        self.lb_name = [[UILabel alloc] init];
        self.lb_name.textColor = color_lbTfLeftTextHex;
        self.lb_name.frame = CGRectMake(self.iv_iconImage.right+kWidth(5), self.iv_iconImage.top, kWidth(70), kWidth(20));
        self.lb_name.textAlignment = NSTextAlignmentCenter;
        self.lb_name.font = [UIFont systemFontOfSize:kWidth(15)];
        self.lb_name;
    })];
    
    [self.contentView addSubview:({
        self.lb_prompt = [[UILabel alloc] init];
        self.lb_prompt.textColor = color_findPwd;
        self.lb_prompt.font = [UIFont systemFontOfSize:kWidth(15)];
        self.lb_prompt.frame = CGRectMake(self.lb_name.right+kWidth(2), self.iv_iconImage.top, kWidth(100), kWidth(20));
        self.lb_prompt;
    })];
    
    [self.contentView addSubview:({
        self.btn_operation = [UIButton buttonWithType:UIButtonTypeCustom];

        [self.btn_operation addTarget:self action:@selector(func_clickAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_operation.frame = CGRectMake(self.lb_prompt.right+kWidth(65), kWidth(5), kWidth(80), kWidth(30));
        self.btn_operation;
    })];
}

- (void)setMenuDic:(NSDictionary *)menuDic{
    NSString *iconStr = [NSString stringWithFormat:@"%@",[menuDic valueForKey:@"icon"]];
    [self.iv_iconImage setImage:kSetBundleImage(iconStr)];
    
    NSString *nameStr = [NSString stringWithFormat:@"%@",[menuDic valueForKey:@"name"]];
    self.lb_name.text = nameStr;
    
    NSString * promptStr = [NSString stringWithFormat:@"%@",[menuDic valueForKey:@"prompt"]];
    self.lb_prompt.text = promptStr;
    
    [self.btn_operation setBackgroundImage:kSetBundleImage([menuDic valueForKey:@"type"]) forState:UIControlStateNormal];
    if ([@"(已实名认证)" isEqualToString:promptStr] || [@"(手机已绑定)" isEqualToString:promptStr]) {
        self.btn_operation.enabled = NO;
        self.lb_prompt.textColor = color_greentHex;
    }
}

- (void)func_clickAction:(UIButton *)sender {
    self.selectionCellBlock();
}

#pragma mark ---- Notification ----
- (void)func_didChangeRotate:(NSNotification *)notice {
    [self setNeedsLayout];
    [self func_setMenuTableViewCell];
}

@end
