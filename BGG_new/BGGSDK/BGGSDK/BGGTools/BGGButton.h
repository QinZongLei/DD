//
//  BGGButton.h
//  Unicorn_iOS_OC
//
//  Created by Qz on 2019/1/11.
//  Copyright © 2019 Liangrc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BGGButtonType) {
    BGGButtonTypeImageNone,
    BGGButtonTypeImageTop,
    BGGButtonTypeImageLeft,
    BGGButtonTypeImageBottom,
    BGGButtonTypeImageRight
};

@interface BGGButton : UIButton

/** 间距 */
@property (assign, nonatomic) CGFloat spacing;
/** 必须先设置宽高 */
@property (assign, nonatomic) BGGButtonType type;
/** 圆角 */
@property (assign, nonatomic) CGFloat imageRadius;
/** 图片大小 */
@property (nonatomic, assign) CGSize imageSize;

- (void)lc_setUnderLineColor:(UIColor *)color text:(NSString *)text;
@end
