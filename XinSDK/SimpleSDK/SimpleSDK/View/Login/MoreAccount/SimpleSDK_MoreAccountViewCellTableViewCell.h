//
//  SimpleSDK_MoreAccountViewCellTableViewCell.h
//  SimpleSDK
//
//  Created by admin on 2021/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SimpleSDK_MoreAccountViewCellTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *accountInfo;

@property (nonatomic, strong) void (^delHandle)(NSDictionary *params);

@end

NS_ASSUME_NONNULL_END
