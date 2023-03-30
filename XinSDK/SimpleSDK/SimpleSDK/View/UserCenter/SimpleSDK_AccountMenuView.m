//
//  SimpleSDK_AccountMenuView.m
//  SimpleSDK
//
//  Created by admin on 2021/12/23.
//

#import "SimpleSDK_AccountMenuView.h"
#import "SimpleSDK_Expose.h"
#import "SimpleSDK_ApiManager.h"
#import "SimpleSDK_MenuTableViewCell.h"
#import "SimpleSDK_DataTools.h"

@interface SimpleSDK_AccountMenuView() <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *btn_back;
@property (nonatomic, strong) UITableView *tb_menuList;
@property (nonatomic, strong) NSMutableArray *moduleList;
@property (nonatomic, strong) UIButton *btn_switchAccount;
@end

@implementation SimpleSDK_AccountMenuView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self  func_addNotification];
        [self  func_setAccountMenuView];
    }
    return self;
}

-(void)func_addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(func_didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

-(void)func_setAccountMenuView{
    self.bgImgVStr = accountSetBgImgV;
    
    NSString * oneClickStr = @"oneClick";
    NSString *accountStr = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"user_name"];
    NSString *newsID = [NSString stringWithFormat:@"%@%@",oneClickStr,accountStr];
    [[NSUserDefaults standardUserDefaults] setObject:@"openAccountMenu" forKey:newsID];
    
    
    self.moduleList = [SimpleSDK_DataTools func_getMenuList];
    
    [self.iv_viewBg addSubview:({
        self.btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_back.frame = CGRectMake(self.iv_viewBg.width - kWidth(40), kWidth(35), kWidth(30), kWidth(30));
        self.btn_back.tag = 20211201;
        [self.btn_back setImage:kSetBundleImage(backBtn) forState:UIControlStateNormal];
        [self.btn_back addTarget:self action:@selector(func_blackAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_back;
    })];
    
    
    [self.iv_viewBg addSubview:({
        self.tb_menuList = [[UITableView alloc] init];
        self.tb_menuList.backgroundColor = [UIColor clearColor];
        self.tb_menuList.dataSource = self;
        self.tb_menuList.delegate = self;
        self.tb_menuList.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.tb_menuList.tableFooterView = [[UIView alloc] init];
        self.tb_menuList.scrollEnabled= NO;
        self.tb_menuList.frame = CGRectMake((self.iv_viewBg.width- (self.iv_viewBg.width-kWidth(60)))/2, self.iv_line.bottom + kWidth(45), self.iv_viewBg.width-kWidth(60), kWidth(125));
//        self.tb_menuList.centerX = self.iv_viewBg.centerX-kWidth(15);
        self.tb_menuList.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tb_menuList registerClass:[SimpleSDK_MenuTableViewCell class] forCellReuseIdentifier:CelliIdentify];
        self.tb_menuList;
    })];
    
    
    [self.iv_viewBg addSubview:({
        self.btn_switchAccount =  [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_switchAccount.frame = CGRectMake((self.iv_viewBg.width-kWidth(180))/2, self.tb_menuList.bottom+kWidth(15), kWidth(180), kWidth(45));
        self.btn_switchAccount.tag = 20211202;
//        self.btn_switchAccount.centerX = self.iv_viewBg.centerX -kWidth(15);
        [self.btn_switchAccount setBackgroundImage:kSetBundleImage(switchImg) forState:UIControlStateNormal];
        [self.btn_switchAccount addTarget:self action:@selector(func_switchAccountAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_switchAccount;
    })];
    
}

- (void)func_blackAction:(UIButton *)sender {
    //返回
    dispatch_async(dispatch_get_main_queue(), ^{
        [SimpleSDK_ViewManager func_showUserCenterView];
        [self removeFromSuperview];
    });
}

- (void)func_switchAccountAction:(UIButton *)sender {
        //切换账号
        dispatch_async(dispatch_get_main_queue(), ^{
            [SimpleSDK_ApiManager func_logout:^(BOOL status) {
                if (self) {
                    [self removeFromSuperview];
                    
                    [[SimpleSDK_Expose sharedInstance] func_startLoginWithBlock:[SimpleSDK_Expose sharedInstance].loginHandle HandleLogout:[SimpleSDK_Expose sharedInstance].logoutHandle];
                }
            }];
        });
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.moduleList.count;
}



- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SimpleSDK_MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CelliIdentify];
    NSDictionary *menuDic = [NSDictionary dictionaryWithDictionary:self.moduleList[indexPath.row]];
    cell.menuDic = menuDic;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    __weak typeof(self)weakSelf = self;
    cell.selectionCellBlock = ^{
        NSString *tempName = [NSString stringWithFormat:@"%@",[menuDic valueForKey:@"name"]];
        [weakSelf func_switchView:tempName];
    };
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kWidth(40);
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
        //设置Cell的两边的间距来控制宽度
    [cell setSeparatorInset:UIEdgeInsetsMake(0, kWidth(40), 0, kWidth(40))];
}



-(void)func_switchView:(NSString *)operationStr{
    if ([@"修改密码" isEqualToString:operationStr]) {
        
     
        NSUserDefaults *wayforlogin = [NSUserDefaults standardUserDefaults];
        NSString *waystr = [wayforlogin objectForKey:@"loginway"];
        if ([@"phoneway" isEqualToString:waystr]) {
            //去修改密码界面
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeFromSuperview];
                [SimpleSDK_ViewManager func_showUpdatephonePwdView];
            });
        }else{
            //去修改密码界面
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeFromSuperview];
                [SimpleSDK_ViewManager func_showUpdatePwdView];
            });
        }
       
      
    }else if([@"实名认证" isEqualToString:operationStr]){
        //去实名认证
        dispatch_async(dispatch_get_main_queue(), ^{
            [SimpleSDK_ViewManager func_showCertificationView:@"3"];
           [self removeFromSuperview];
        });
    }else if([@"绑定手机" isEqualToString:operationStr]){
        //去绑定手机
        dispatch_async(dispatch_get_main_queue(), ^{
           [SimpleSDK_ViewManager func_showBindPhoneView];
           [self removeFromSuperview];
        });
    }
}

#pragma mark ---- Notification ----
- (void)func_didChangeRotate:(NSNotification *)notice {
    [self setNeedsLayout];
    [self func_setAccountMenuView];
}

@end
