//
//  SimpleSDK_MsgListView.m
//  SimpleSDK
//
//  Created by mac on 2021/12/20.
//

#import "SimpleSDK_MsgListView.h"
#import "SImpleSDK_DataTools.h"
#import "SimpleSDK_MsgListTableViewCell.h"

@interface SimpleSDK_MsgListView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIButton *btn_back;
@property (nonatomic, strong) UITableView *tb_msgList;
@property (nonatomic, strong) NSMutableArray *msgDic;
@end

@implementation SimpleSDK_MsgListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self  func_addNotification];
        [self func_setMsgListView];
    }
    return self;
}

-(void)func_addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(func_didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

-(void)func_setMsgListView{
    self.bgImgVStr = noticeBgImgV;
    
    self.msgDic = [SimpleSDK_DataTools manager].msgInfo;
    
 
    [self.iv_viewBg addSubview:({
        self.btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_back.frame = CGRectMake(self.iv_viewBg.width - kWidth(40), kWidth(35), kWidth(30), kWidth(30));
        self.btn_back.tag = 20211201;
        [self.btn_back setImage:kSetBundleImage(backBtn) forState:UIControlStateNormal];
        [self.btn_back addTarget:self action:@selector(func_clickAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_back;
    })];
    
    [self.iv_viewBg addSubview:({
        self.tb_msgList = [[UITableView alloc] init];
        self.tb_msgList.backgroundColor = [UIColor clearColor];
        self.tb_msgList.dataSource = self;
        self.tb_msgList.delegate = self;
        self.tb_msgList.tableFooterView = [[UIView alloc] init];
        self.tb_msgList.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.tb_msgList.separatorColor = color_agreement;
        if (self.msgDic.count >0) {
            [self.tb_msgList registerClass:[SimpleSDK_MsgListTableViewCell class] forCellReuseIdentifier:CelliIdentify];
            self.tb_msgList.rowHeight = kWidth(40);
            self.tb_msgList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }else{
            self.tb_msgList.rowHeight = self.iv_viewBg.height - kWidth(115);
            self.tb_msgList.scrollEnabled = NO;
            self.tb_msgList.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.tb_msgList registerClass:[UITableViewCell class] forCellReuseIdentifier:CelliIdentify];
        }
        self.tb_msgList.frame = CGRectMake((self.iv_viewBg.width-(self.iv_viewBg.width-kWidth(40)))/2, self.iv_line.bottom+kWidth(20), self.iv_viewBg.width-kWidth(40), self.iv_viewBg.height- kWidth(115));
        self.tb_msgList;
    })];
}

- (void)func_clickAction:(UIButton *)sender {
        //返回
        dispatch_async(dispatch_get_main_queue(), ^{
            [SimpleSDK_ViewManager func_showUserCenterView];
            [self removeFromSuperview];
        });
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.msgDic.count >0) {
        return self.msgDic.count;
        
    }
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.msgDic.count >0){
        SimpleSDK_MsgListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CelliIdentify];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.msgDic = [self.msgDic objectAtIndex: indexPath.row];
     return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CelliIdentify];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CelliIdentify];
        }
        UILabel *showNewsTipLb = [[UILabel alloc] init];
        showNewsTipLb.frame = CGRectMake((self.iv_viewBg.width-kWidth(140))/2, (self.tb_msgList.height-kWidth(40))/2, kWidth(120), kWidth(40));
        showNewsTipLb.text = @"暂无消息~";
        showNewsTipLb.textAlignment = NSTextAlignmentCenter;
        showNewsTipLb.textColor = color_agreement_tip;
        [cell addSubview:showNewsTipLb];
        cell.userInteractionEnabled = NO;
        cell.backgroundColor = [UIColor clearColor];

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary * msgDic = [self.msgDic objectAtIndex: indexPath.row];
    [SimpleSDK_ViewManager func_showMsgDetailsView:msgDic];
    NSString *accountStr = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"user_name"];
    NSString *newsID = [NSString stringWithFormat:@"%@%@",[msgDic objectForKey:@"id"],accountStr];
    [[NSUserDefaults standardUserDefaults] setObject:@"redIshidden" forKey:newsID];
    [self.tb_msgList reloadData];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
        //设置Cell的两边的间距来控制宽度
    [cell setSeparatorInset:UIEdgeInsetsMake(0, kWidth(30), 0, kWidth(30))];
}

#pragma mark ---- Notification ----
- (void)func_didChangeRotate:(NSNotification *)notice {
    [self setNeedsLayout];
    [self func_setMsgListView];
}

@end
