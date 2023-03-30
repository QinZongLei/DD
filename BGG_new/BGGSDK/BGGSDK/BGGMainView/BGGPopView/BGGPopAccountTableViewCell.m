//
//  BGGPopAccountTableViewCell.m
//  BGGSDK
//
//  Created by 李胜 on 2021/6/4.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGPopAccountTableViewCell.h"
#import "BGGPCH.h"
#import "BGGDeleteAccountBtn.h"

@interface BGGPopAccountTableViewCell()
@property(nonatomic,strong)UILabel *accountLab;
@property(nonatomic,strong)UILabel *typeLabel;
@property(nonatomic,strong)BGGDeleteAccountBtn *deleteButton;
@end


@implementation BGGPopAccountTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createUI];
        
        
    }
    return self;
}


-(void)createUI{
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.userInteractionEnabled = YES;
    self.accountLab =[BGGView labelWithTextColor:BGGGrayColor backColor:nil textAlignment:NSTextAlignmentLeft lineNumber:1 text:@"13689501309" font:Font(14)];
    [self addSubview:self.accountLab];
    [self.accountLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(10);
            make.height.equalTo(@20);
    }];
    
   
    
    self.deleteButton = [[BGGDeleteAccountBtn alloc] init];
    [self.deleteButton setupStyle:BGGLightGrayColor];
    [self.deleteButton addTarget:self action:@selector(deleteBUtton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.deleteButton];
    self.deleteButton.userInteractionEnabled = YES;
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@30);
            make.right.equalTo(self.contentView.mas_right).offset(-5);
            make.centerY.equalTo(self.contentView.mas_centerY);
            
    }];
    
    self.typeLabel = [BGGView labelWithTextColor:BGGGrayColor backColor:nil textAlignment:NSTextAlignmentLeft lineNumber:1 text:@"账号" font:Font(14)];
    [self addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.deleteButton.mas_left).offset(-10);
            make.height.equalTo(@20);
    }];
    
}
-(void)setAccountDic:(NSDictionary *)accountDic{
    _accountDic = accountDic;
    self.accountLab.text = _accountDic[@"account"];
    if (self.accountLab.text.length == 11) {
        self.typeLabel.text = @"手机号";
    }else{
        self.typeLabel.text = @"账号";
    }
}

-(void)deleteBUtton:(BGGButton *)button{
    if (self.deleteAccountBlock) {
        self.deleteAccountBlock(self.accountDic);
    }
}
@end
