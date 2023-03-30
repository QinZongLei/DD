//
//  BGGDragButton.h
//  SYSDK
//
//  Created by ls on 2017/11/29.
//  lsjy
//

#import <UIKit/UIKit.h>

@interface SYFloatWindow : UIWindow
@property (nonatomic, assign) CGRect floatFrame;

@end

/**
 *  代理按钮的点击事件
 */
@protocol UIDragButtonDelegate <NSObject>

- (void)dragButtonClicked:(UIButton *)sender;



@end

@interface BGGDragButton : UIButton

/**
 *  悬浮的window
 */
@property(strong,nonatomic) SYFloatWindow *window;
/**
 *  悬浮窗所依赖的根视图
 */
@property (nonatomic, strong)UIView *rootView;

/**
 *  UIDragButton的点击事件代理
 */
@property (nonatomic, weak)id<UIDragButtonDelegate>btnDelegate;


/**
*  新消息的提示label
*/
@property(nonatomic,strong)UILabel *noticeLab;

@end

