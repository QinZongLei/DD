//
//  SimpleSDK_UserCenterView.m
//  SimpleSDK
//
//  Created by admin on 2021/12/22.
//

#import "SimpleSDK_UserCenterView.h"
#import "SimpleSDK_DataTools.h"
#import "SimpleSDK_MenuCollectionViewCell.h"
#import "SimpleSDK_ApiManager.h"
#import "SimpleSDK_Expose.h"

#define kLineSpacing  kWidth(10.f)   //列间距
#define kRowNumber    4     //列数

@interface SimpleSDK_UserCenterView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UIView *view;
@property(nonatomic,strong)UIImageView *iv_viewBg;
@property(nonatomic,strong)UIImageView *iv_userImg;
@property(nonatomic,strong) UILabel *lb_userName;
@property(nonatomic,strong) UILabel *lb_userId;
@property(nonatomic,strong) UIImageView *iv_line;
@property (nonatomic, strong) UIButton *btn_back;
@property (nonatomic, strong) UICollectionViewFlowLayout *userLayout;
@property (nonatomic, strong) UICollectionView *userCvModul;
@property (nonatomic, strong) NSMutableArray *userModuleList;
@property (nonatomic, strong) UIButton *btn_publcCode;
@property (nonatomic, strong) UIButton *btn_switchAccount;
@end

@implementation SimpleSDK_UserCenterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self  func_addNotification];
        [self func_setUserCenterView];
    }
    return self;
}

-(void)func_addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(func_didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

-(void)func_setUserCenterView{
 
    
    NSString * accountStr = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"user_name"];
    NSString * userIdStr =[[SimpleSDK_DataTools manager].userInfo objectForKey:@"uid"];
    
    [self addSubview:({
        self.view = [[UIView alloc] init];
        self.view.layer.masksToBounds = YES;
        self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);

        self.view.backgroundColor = [UIColor clearColor];
        self.view;
    })];
    
    [self.view addSubview:({
        self.iv_viewBg = [[UIImageView alloc] init];
        self.iv_viewBg.userInteractionEnabled = YES;
        self.iv_viewBg.frame = CGRectMake(0,0, kWidth(450), kWidth(320));
        self.iv_viewBg.center = self.view.center;
        self.iv_viewBg.image = kSetBundleImage(dialogCenterBg);
        self.iv_viewBg;
    })];
    
    [self.iv_viewBg addSubview:({
        self.iv_userImg = [[UIImageView alloc] init];
        self.iv_userImg.frame = CGRectMake(kWidth(55), kWidth(65), kWidth(50), kWidth(50));
        self.iv_userImg.image = kSetBundleImage(userIcon);

        self.iv_userImg;
    })];
    
    NSString *accountTip = [NSString stringWithFormat:@"账号: %@", accountStr];
    NSMutableAttributedString *accountColorArray = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"账号: %@", accountStr]];
    NSString *tip = [NSString stringWithFormat:@"%@",[accountTip substringToIndex:3]];
    NSRange tipColor = [[accountColorArray string] rangeOfString:tip];
    [accountColorArray addAttribute:NSForegroundColorAttributeName value:color_center_uidAccount range:tipColor];
    NSString *account = [NSString stringWithFormat:@"%@",[accountTip substringFromIndex:3]];
    NSRange accountColor = [[accountColorArray string] rangeOfString:account];
    [accountColorArray addAttribute:NSForegroundColorAttributeName value:color_center_uidAccount  range:accountColor];
    
    [self.iv_viewBg addSubview:({
        self.lb_userName = [[UILabel alloc] init];
        self.lb_userName.frame = CGRectMake(self.iv_userImg.right+kWidth(5), self.iv_userImg.top+kWidth(2), kWidth(200), kWidth(20));
        [self.lb_userName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kWidth(14)]];
        self.lb_userName.attributedText = accountColorArray;

        self.lb_userName;
    })];
    
    [self.iv_viewBg addSubview:({
        self.btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_back.tag = 20211201;
        self.btn_back.frame = CGRectMake(self.iv_viewBg.width - kWidth(40), kWidth(35), kWidth(30), kWidth(30));
        [self.btn_back setBackgroundImage:kSetBundleImage(backBtn) forState:UIControlStateNormal];
        [self.btn_back addTarget:self action:@selector(func_shutAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_back;
    })];
    
    
    NSString *uidTip = [NSString stringWithFormat:@"用户ID: %@", userIdStr];
    NSMutableAttributedString *uidColorArray = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"用户ID: %@", userIdStr]];
    NSString *utip = [NSString stringWithFormat:@"%@",[uidTip substringToIndex:5]];
    NSRange uidTipColor = [[uidColorArray string] rangeOfString:utip];
    [uidColorArray addAttribute:NSForegroundColorAttributeName value:color_center_uidAccount range:uidTipColor];
    NSString *uid = [NSString stringWithFormat:@"%@",[uidTip substringFromIndex:5]];
    NSRange uidColor = [[uidColorArray string] rangeOfString:uid];
    [uidColorArray addAttribute:NSForegroundColorAttributeName value:color_center_uidAccount  range:uidColor];
    [self.iv_viewBg addSubview:({
        self.lb_userId = [[UILabel alloc] init];
        self.lb_userId.frame = CGRectMake(self.lb_userName.left, self.lb_userName.bottom+kWidth(5), self.lb_userName.width, self.lb_userName.height);
        [self.lb_userId setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kWidth(14)]];
        self.lb_userId.attributedText = uidColorArray;
        self.lb_userId;
    })];
    
 
    
    [self.iv_viewBg addSubview:({
        self.iv_line = [[UIImageView alloc] init];
        self.iv_line.frame = CGRectMake((self.iv_viewBg.width - (self.iv_viewBg.width-kWidth(80)))/2, self.lb_userId.bottom+kWidth(5), self.iv_viewBg.width-kWidth(80), kWidth(1));
        self.iv_line.image = kSetBundleImage(lineImg);

        self.iv_line;
    })];
    
    //获取菜单列表
    self.userModuleList =  [SimpleSDK_DataTools func_getUserCenter];
    
    [self.iv_viewBg addSubview:({
        self.userLayout = [[UICollectionViewFlowLayout alloc] init];
        self.userLayout.minimumLineSpacing = kLineSpacing;
       
        self.userLayout.minimumInteritemSpacing = kWidth(4);
        self.userLayout.itemSize = CGSizeMake((self.iv_viewBg.width-kWidth(140))/kRowNumber, (self.iv_viewBg.width-kWidth(140))/kRowNumber);
        
        self.userLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.userCvModul = [[UICollectionView alloc] initWithFrame:CGRectMake(kWidth(60), self.iv_line.bottom + kWidth(5), self.iv_viewBg.width - kWidth(110), kWidth(90)) collectionViewLayout:self.userLayout];
        self.userCvModul.delegate = self;
        self.userCvModul.dataSource = self;
        [self.userCvModul registerClass:[SimpleSDK_MenuCollectionViewCell class]forCellWithReuseIdentifier:CelliIdentify];
        self.userCvModul.showsVerticalScrollIndicator = NO;
        self.userCvModul.showsHorizontalScrollIndicator = NO;
        self.userCvModul.backgroundColor = [UIColor clearColor];
        self.userCvModul;
    })];
    
    [self.iv_viewBg addSubview:({
        self.btn_publcCode = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_publcCode.frame = CGRectMake(self.iv_viewBg.width/2 - kWidth(130), self.userCvModul.bottom+kWidth(1), kWidth(260), kWidth(20));
        self.btn_publcCode.tag = 20211202;
        self.btn_publcCode.backgroundColor = [UIColor clearColor];
        self.btn_publcCode.titleLabel.font = [UIFont systemFontOfSize:kWidth(14)];

        [self.btn_publcCode setAttributedTitle:[SimpleSDK_Tools func_strAddUnderline:@"关注公众号：更多福利活动等您来参与" UnderLineColor:color_agreement] forState: 0];
        [self.btn_publcCode setTitleColor:color_agreement forState:UIControlStateNormal];
        [self.btn_publcCode addTarget:self action:@selector(func_showCodeAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_publcCode;
    })];
    
    [self.iv_viewBg addSubview:({
        self.btn_switchAccount = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_switchAccount.frame = CGRectMake((self.iv_viewBg.width-kWidth(180))/2, self.btn_publcCode.bottom+kWidth(10), kWidth(180), kWidth(45));
        self.btn_switchAccount.tag = 20211203;
        [self.btn_switchAccount setBackgroundImage:kSetBundleImage(switchImg) forState:UIControlStateNormal];
        [self.btn_switchAccount addTarget:self action:@selector(func_switchAccountAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_switchAccount.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.btn_switchAccount;
    })];
}

- (void)func_shutAction:(UIButton *)sender {
    //关闭当前界面
    dispatch_async(dispatch_get_main_queue(), ^{
        [SimpleSDK_ViewManager func_showFloatView];
        [SimpleSDK_ViewManager func_showGiftFloatView];
        [self removeFromSuperview];
    });
}

- (void)func_showCodeAction:(UIButton *)sender {
    //显示公众号界面
    dispatch_async(dispatch_get_main_queue(), ^{
        [SimpleSDK_ViewManager func_showPublicCodeView];
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userModuleList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   SimpleSDK_MenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CelliIdentify forIndexPath: indexPath];
    cell.cellDic = self.userModuleList[indexPath.row];
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tempDic = self.userModuleList[indexPath.row];
    NSString *tempName = [tempDic valueForKey:@"name"];
    if ([tempName isEqualToString: @"公告"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SimpleSDK_ViewManager func_showMsgListView];
            [self removeFromSuperview];
        });
    }else if ([tempName isEqualToString:@"账号"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [SimpleSDK_ViewManager func_showAccountMenuView];
            [self removeFromSuperview];
        });
    }else if ([tempName isEqualToString:@"公众号"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [SimpleSDK_ViewManager func_showPublicCodeView];
            [self removeFromSuperview];
        });
    }else if ([tempName isEqualToString:@"联系客服"]){
        //找客服
        NSString * urlStr = [[SimpleSDK_DataTools manager].customerInfo objectForKey:@"service_url"];
        if (!kStringIsNull(urlStr)) {
            [SimpleSDK_ViewManager func_showHelpView:urlStr];
        }
    }
}


////边距设置:整体边距的优先级，始终高于内部边距的优先级
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(kWidth(5), kWidth(0),kWidth(5), kWidth(0));//分别为上、左、下、右
}



#pragma mark ---- Notification ----
- (void)func_didChangeRotate:(NSNotification *)notice {
    [self setNeedsLayout];
    [self func_setUserCenterView];
}
@end
