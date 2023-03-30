//
//  BGGPopAccountView.m
//  BGGSDK
//
//  Created by 李胜 on 2021/6/4.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGPopAccountView.h"
#import "BGGPCH.h"
#import "BGGPopAccountTableViewCell.h"
@interface BGGPopAccountView()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;;

@end
@implementation BGGPopAccountView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
       if (self) {
           self.dataArray = [[NSMutableArray alloc] initWithArray:[BGGDataModel sharedInstance].accountArray];
           [self createUI];
       }
       return self;
}


-(void)createUI{
    self.backgroundColor = BGGWhiteColor;
    self.layer.cornerRadius = 2;
    self.layer.borderColor = BGGLightGrayColor.CGColor;
    self.layer.borderWidth = 0.5;
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(1);
            make.left.equalTo(self.mas_left).offset(1);
            make.right.equalTo(self.mas_right).offset(-1);
            make.bottom.equalTo(self.mas_bottom).offset(-1);
    }];
    
    
}
#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifier = @"cell1";
    BGGPopAccountTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[BGGPopAccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accountDic = self.dataArray[indexPath.row];
    SYWeakObject(self);
    cell.deleteAccountBlock = ^(NSDictionary * _Nonnull accountDic) {
        [weak_self.dataArray removeObjectAtIndex:indexPath.row];
        
      
        [BGGDataModel sharedInstance].accountArray = weak_self.dataArray;
    
        
        if (weak_self.dataArray.count == 0) {
            [weak_self removeFromSuperview];
        }
        [weak_self.tableView reloadData];
    };
    
    return cell;



 
    
  
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selAccountBlock) {
        self.selAccountBlock([BGGDataModel sharedInstance].accountArray[indexPath.row]);
    }

    

    
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = YES;
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.showsHorizontalScrollIndicator = false;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
