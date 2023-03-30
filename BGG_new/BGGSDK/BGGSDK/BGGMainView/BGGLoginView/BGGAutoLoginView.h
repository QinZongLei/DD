//
//  BGGAutoLoginView.h
//  BGGSDK
//
//  Created by 李胜 on 2021/6/15.
//  Copyright © 2021 BGG. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGGAutoLoginView : UIView
@property (nonatomic, copy) void (^qieHuanBlock)(void);
@property(nonatomic,strong)NSString *account;

@end

NS_ASSUME_NONNULL_END
