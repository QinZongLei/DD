//
//  SimpleSDK_MoreAccountViewCellTableViewCell.m
//  SimpleSDK
//
//  Created by admin on 2021/12/21.
//

#import "SimpleSDK_MoreAccountViewCellTableViewCell.h"
#import "SimpleSDK_DataTools.h"

@interface SimpleSDK_MoreAccountViewCellTableViewCell()
@property (nonatomic, strong) UIImageView *iv_icon;
@property (nonatomic, strong) UILabel *lb_userName;
@property (nonatomic, strong) UIButton *btn_del;
@property (nonatomic, strong) UIView *iv_line;
@end

@implementation SimpleSDK_MoreAccountViewCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self func_addNotification];
        [self func_setupCellView];
    }
    return self;
}

- (void)func_addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(func_didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

-(void)func_setupCellView{
    [self.contentView addSubview:({
        self.iv_icon = [[UIImageView alloc] initWithImage:kSetBundleImage(accountLoginBtn)];
        self.iv_icon.frame = CGRectMake(kWidth(12), kWidth(10), kWidth(16), kWidth(18));
        self.iv_icon;
    })];
    
    [self.contentView addSubview:({
        self.lb_userName = [[UILabel alloc] init];
        self.lb_userName.frame = CGRectMake(self.iv_icon.right+kWidth(5), kWidth(10), kWidth(170), kWidth(18));
        self.lb_userName.font = [UIFont systemFontOfSize:kWidth(13)];
        self.lb_userName.textColor = [UIColor blackColor];
        self.lb_userName ;
    })];
    
    [self.contentView addSubview:({
        self.btn_del = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_del.frame = CGRectMake(self.lb_userName.right+kWidth(5), kWidth(7), kWidth(24), kWidth(24));
        [self.btn_del setTitle:@"╳" forState:0];
        self.btn_del.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.btn_del setTitleColor:[UIColor blackColor] forState:0];
        [self.btn_del addTarget:self action:@selector(func_delAccountAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_del;
    })];
    
    [self.contentView addSubview:({
        self.iv_line = [[UIView alloc] init];
        self.iv_line.frame = CGRectMake(kWidth(12), kWidth(36), kWidth(320) - kWidth(48) - kWidth(24), kWidth(1));
        self.iv_line.backgroundColor = RGBHEX(0xBCBCBC);
        self.iv_line;
    })];
}

- (void)setAccountInfo:(NSDictionary *)accountInfo{
    _accountInfo = accountInfo;
    self.lb_userName.text = [NSString stringWithFormat:@"%@",[_accountInfo valueForKey:@"account"]];
}


- (void)func_delAccountAction:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除该条账号信息" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *delAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *tempAccount = [NSString stringWithFormat:@"%@", [self.accountInfo valueForKey:@"account"]];
            [SimpleSDK_DataTools func_deleteAccount:tempAccount];
            self.delHandle(self.accountInfo);
        });
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:delAction];
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [topVC presentViewController:alert animated:YES completion:nil];
}

- (void)func_didChangeRotate:(NSNotification *)notice {
    [self setNeedsLayout];
    [self func_setupCellView];
}
@end
