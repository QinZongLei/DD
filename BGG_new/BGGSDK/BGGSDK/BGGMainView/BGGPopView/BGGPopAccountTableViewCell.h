//
//  BGGPopAccountTableViewCell.h
//  BGGSDK
//
//  Created by 李胜 on 2021/6/4.
//  Copyright © 2021 BGG. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGGPopAccountTableViewCell : UITableViewCell
@property (nonatomic, copy) void (^deleteAccountBlock)(NSDictionary *accountDic);
@property(nonatomic,strong)NSDictionary *accountDic;
@end

NS_ASSUME_NONNULL_END
