//
//  BGGMenuView.m
//  BGGSDK
//
//  Created by 李胜 on 2021/5/27.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGMenuView.h"
#import "BGGPCH.h"
#import "MenuCollectionViewCell.h"
#import "BGGWKWebview.h"
#import "BGGCloseButton.h"
@interface BGGMenuView()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UILabel *nickNameLab;
@property(nonatomic,strong)BGGButton *qieHuanBtn;
@property(nonatomic,strong)BGGButton *closeBtn;
@property(nonatomic,strong)UICollectionView *menuCollectionView;
@property(nonatomic,strong)NSArray *imageNameArray;
@property(nonatomic,strong)NSArray *titleArray;
@end
@implementation BGGMenuView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
       if (self) {
           self.leftButton.hidden = YES;
           self.titView.hidden = NO;
           self.layer.cornerRadius = 10;
           [self.titView removeFromSuperview];
           self.logoImageView.hidden = YES;
          
           self.imageNameArray = @[@{@"1":@"MENUFloatAccount"},@{@"2":@"MENUFloatGift"},@{@"3":@"MENUFloatGg"},@{@"4":@"MENUFloatService"},@{@"5":@"MENUFloatGzh"},@{@"6":@"MENUFloatGzh"}];
           
           [self createUI];
       }
       return self;
}
-(void)createUI{
   // self.backgroundColor = Color_hexA(@"#4a4948", 0.8);
    UIView *lineView = [[UIView alloc] init];
    [self addSubview:lineView];
    lineView.backgroundColor = Color_hexA(@"#c0c0c0", 0.5);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@1);
        make.top.equalTo(self.mas_top).offset(90);
    }];
    
    BGGCloseButton *closeBtn = [[BGGCloseButton alloc] init];
    [closeBtn setupStyle:BGGLightGrayColor];
    [self addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(closeButton:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@50);
            make.top.equalTo(self.mas_top).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
    }];
    
    self.headImageView = [BGGView imageViewWithImage:nil];
    [self addSubview:self.headImageView];
    self.headImageView.backgroundColor = [UIColor redColor];
    self.headImageView.layer.cornerRadius = 25;
    self.headImageView.image =  [UIImage BGGGetImage:@"MENUIconDefault"];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.width.height.equalTo(@50);
        make.top.equalTo(self.mas_top).offset(20);
    }];
    
    self.nickNameLab = [BGGView labelWithTextColor:BGGWhiteColor backColor:nil textAlignment:NSTextAlignmentLeft lineNumber:1 text:@"lslslsl" font:Font(16)];
    [self addSubview:self.nickNameLab];
    [self.nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.centerY.equalTo(self.headImageView.mas_centerY);
        make.height.equalTo(@20);
    }];
    self.nickNameLab.text = [BGGDataModel sharedInstance].userName;
    
    self.qieHuanBtn = [BGGView buttonWithFrame:CGRectZero title:@"[切换]" titleColor:Color_hexA(@"#979797", 0.8) selTitle:nil selTitlecColor:nil backColor:nil font:Font(18 ) target:self sel:@selector(qieHuanBtn:) action:nil];
    [self addSubview:self.qieHuanBtn];
    [self.qieHuanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickNameLab.mas_right).offset(7);
        make.height.equalTo(@30);
        make.width.equalTo(@45);
        make.centerY.equalTo(self.nickNameLab.mas_centerY);
    }];
    
    if ([BGGDataModel sharedInstance].floatWindowsVoList.count < 5) {
        CGRect rect = KBGGMenuRect;
        self.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height -83);
    }else{
        self.frame = KBGGMenuRect;
    }
    
    if ([BGGDataModel sharedInstance].floatWindowsVoList.count) {
        [self addSubview:self.menuCollectionView];
        self.menuCollectionView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = ColorRGBA(18, 19, 26, 0.8);
        [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
            make.top.equalTo(lineView.mas_bottom);
        }];
    }
    
    
    
}
-(void)closeButton:(BGGButton *)button{
    [self dismiss];
    [BGGAPI sharedAPIManeger].hideDragBtn = NO;
}
#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [BGGDataModel sharedInstance].floatWindowsVoList.count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    
    MenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.typeLab.text = [[BGGDataModel sharedInstance].floatWindowsVoList[indexPath.item] objectForKey:@"name"];
  __block  NSString *imgName = @"";
    [self.imageNameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = obj;
        if ([[[dic allKeys] firstObject]  isEqualToString:[[[BGGDataModel sharedInstance].floatWindowsVoList[indexPath.item] objectForKey:@"type"] stringValue]]) {
            imgName = [[dic allValues] firstObject] ;
        }
    }];
    cell.imgView.image = [UIImage BGGGetImage:imgName];
    return cell;
    
}


#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    
        return CGSizeMake(0, 0);
    
    
    
}
#pragma mark - cell 大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   
         return CGSizeMake(self.frame.size.width/4.0,70);
   
}

#pragma mark - Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
   
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
  
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}


#pragma mark - 同一行cell的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
    
    
    
}
#pragma mark - cell 行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
        return 2;
   
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
        
        BGGWKWebview *weView = [[BGGWKWebview alloc]initWithFrame:KBGGRuleRect];
        weView.center = [self getPopControllerCenter];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = [BGGDataModel sharedInstance].sdkUserToken;
        dict[@"appNumber"] = [BGGDataModel sharedInstance].appNumber;
        dict[@"teamCompanyNumber"] = [BGGDataModel sharedInstance].teamCompanyNumber;
        dict[@"channelNumber"] = [BGGDataModel sharedInstance].channelNumber;
        dict[@"number"] = [BGGDataModel sharedInstance].number;
        dict[@"deviceType"] = @"Ios";
        weView.paramDic = dict;
        weView.webUrl = [[BGGDataModel sharedInstance].floatWindowsVoList[indexPath.item] objectForKey:@"h5Url"];
        
        
        [self pushToView:weView currentView:self];
    
}

-(void)qieHuanBtn:(BGGButton *)button{
    [self dismiss];
    [[BGGAPI sharedAPIManeger] BGGSDKLogout];
    [BGGAPI sharedAPIManeger].hideDragBtn = YES;
}


-(UICollectionView *)menuCollectionView{
    if (!_menuCollectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _menuCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _menuCollectionView.delegate  = self;
        _menuCollectionView.dataSource = self;
        _menuCollectionView.scrollEnabled = YES;
        _menuCollectionView.layer.cornerRadius = BGGCornerRadius;
        [_menuCollectionView registerClass:[MenuCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

        
    }
    
    return _menuCollectionView;
}
@end
