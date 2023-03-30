//
//  SimpleSDK_MenuTableViewCell.h
//  SimpleSDK
//
//  Created by admin on 2021/12/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SimpleSDK_MenuTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^selectionCellBlock)(void);

@property (nonatomic, strong) NSDictionary *menuDic;


@end

NS_ASSUME_NONNULL_END
