//
//  SimpleSDK_MoreAccountView.m
//  SimpleSDK
//
//  Created by admin on 2021/12/21.
//

#import "SimpleSDK_MoreAccountView.h"
#import "SimpleSDK_MoreAccountViewCellTableViewCell.h"
#import "SimpleSDK_DataTools.h"

@interface SimpleSDK_MoreAccountView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) CGRect moreFrame;
@property (nonatomic, strong) UITableView *tvAccount;
@property (nonatomic, strong) NSArray *dataSources;
@end

@implementation SimpleSDK_MoreAccountView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.moreFrame = frame;
        [self func_addNotification];
        [self func_setMoreAccountView];
        [self func_setMoreLayout];
       
    }
    return self;
}

- (void)func_addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(func_didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}


-(void)func_setMoreAccountView{
    self.dataSources = [NSArray arrayWithArray:[SimpleSDK_DataTools func_getAllAccount]];
    
    [self addSubview:({
        self.tvAccount = [[UITableView alloc] init];
        self.tvAccount.backgroundColor = [UIColor clearColor];
        self.tvAccount.dataSource = self;
        self.tvAccount.delegate = self;
        self.tvAccount.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.tvAccount.tableFooterView = [[UIView alloc] init];
        self.tvAccount.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tvAccount registerClass:[SimpleSDK_MoreAccountViewCellTableViewCell class] forCellReuseIdentifier:CelliIdentify];
        self.tvAccount;
    })];
}


- (void)func_setMoreLayout{
    
    CGFloat rowLayout_height = 0;
    
    if (self.dataSources.count >=3) {
        
        rowLayout_height = 3 * kWidth(38);
    } else {
        rowLayout_height = self.dataSources.count * kWidth(38);
    }
    
    self.layer.cornerRadius = kWidth(5);
    self.tvAccount.frame = CGRectMake(0, 0, CGRectGetWidth(self.moreFrame), rowLayout_height);
    self.tvAccount.rowHeight = kWidth(38);
    
}
#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SimpleSDK_MoreAccountViewCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CelliIdentify];
    NSDictionary *accountInfo = [NSDictionary dictionaryWithDictionary:self.dataSources[indexPath.row]];
    cell.accountInfo = accountInfo;
    __weak typeof(self)weakSelf = self;
    cell.delHandle = ^(NSDictionary * _Nonnull params) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.dataSources = [NSArray arrayWithArray:[SimpleSDK_DataTools func_getAllAccount]];
            [weakSelf func_setMoreLayout];
            [weakSelf.tvAccount reloadData];
            if (weakSelf.delHandle) {
                weakSelf.delHandle();
            }
        });
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dicSelect = [NSDictionary dictionaryWithDictionary:self.dataSources[indexPath.row]];
    self.selectHandle(dicSelect);
    [self removeFromSuperview];
}

- (void)func_didChangeRotate:(NSNotification *)notice {
    [self setNeedsLayout];
    [self func_setMoreLayout];
}

@end
