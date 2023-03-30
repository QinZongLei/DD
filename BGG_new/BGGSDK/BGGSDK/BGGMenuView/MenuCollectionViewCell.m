//
//  MenuCollectionViewCell.m
//  BGGSDK
//
//  Created by 李胜 on 2021/5/27.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "MenuCollectionViewCell.h"
#import "BGGPCH.h"
@interface MenuCollectionViewCell()

@end
@implementation MenuCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self setUpUI];
        
    }
    return self;
}
-(void)setUpUI{
    
    self.imgView = [BGGView imageViewWithImage:nil];
    [self addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.width.height.equalTo(@30);
            make.top.equalTo(self.mas_top).offset(20);
    }];
    
    self.typeLab = [BGGView labelWithTextColor:BGGWhiteColor backColor:nil textAlignment:NSTextAlignmentCenter lineNumber:1 text:nil font:Font(13)];
    [self addSubview:self.typeLab];
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.imgView.mas_bottom).offset(5);
            make.height.equalTo(@15);
    }];
    
}
@end
