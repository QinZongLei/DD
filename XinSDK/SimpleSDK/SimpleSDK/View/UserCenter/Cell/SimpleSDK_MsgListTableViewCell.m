//
//  SimpleSDK_MsgListTableViewCell.m
//  SimpleSDK
//
//  Created by admin on 2021/12/23.
//

#import "SimpleSDK_MsgListTableViewCell.h"
#import "SimpleSDK_DataTools.h"

@interface SimpleSDK_MsgListTableViewCell()

@property (nonatomic, strong) UILabel *lb_title;
@end

@implementation SimpleSDK_MsgListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self func_setMsgListTableViewCell];
    }
    return self;
}

-(void)func_setMsgListTableViewCell{
    [self.contentView addSubview:({
        self.lb_title = [[UILabel alloc] init];
        self.lb_title.font = [UIFont systemFontOfSize:kWidth(15)];
        self.lb_title.text = @"标题";
        self.lb_title.textColor = [UIColor redColor];
        self.lb_title.frame = CGRectMake(kWidth(40), kWidth(5), SCREENWIDTH -kWidth(80), kWidth(30));
        self.lb_title;
    })];
}

- (void)setMsgDic:(NSDictionary *)msgDic{
    self.lb_title.text = [NSString stringWithFormat:@"%@",[msgDic objectForKey:@"title"]];
    
    //处理消息标红问题
    NSString *accountStr = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"user_name"];
    NSString * idStr = [NSString stringWithFormat:@"%@%@",[msgDic objectForKey:@"id"],accountStr];
    NSString *redHiddenStr = [[NSUserDefaults standardUserDefaults] objectForKey:idStr];
    if ([@"redIshidden" isEqualToString:redHiddenStr]) {
        self.lb_title.textColor = color_agreement_tip;
    }
}

@end
