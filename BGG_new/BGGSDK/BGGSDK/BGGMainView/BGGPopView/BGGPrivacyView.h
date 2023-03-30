//
//  BGGPrivacyView.h
//  BGGSDK
//
//  Created by 李胜 on 2021/9/27.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGMainBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BGGPrivacyView : BGGMainBaseView
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)titleString content:(NSString *)contentString;
@property (nonatomic, copy) void (^agreeBlock)(void);

@end

NS_ASSUME_NONNULL_END
