//
//  SimpleSDK_MoreAccountView.h
//  SimpleSDK
//
//  Created by admin on 2021/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SimpleSDK_MoreAccountView : UIView

@property (nonatomic, strong) void (^delHandle)(void);

@property (nonatomic, strong) void (^selectHandle)(NSDictionary *accountInfo);

@end

NS_ASSUME_NONNULL_END
