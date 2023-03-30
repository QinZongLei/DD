//
//  BGGForgetPWDView.h
//  BGGSDK
//
//  Created by 李胜 on 2021/5/26.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGMainBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BGGForgetPWDView : BGGMainBaseView
@property (nonatomic, copy) void (^setPWDSuccessBlock)(NSString *phone,NSString *pwd);
@end

NS_ASSUME_NONNULL_END
