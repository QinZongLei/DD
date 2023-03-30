//
//  BGGDragButton.m
//  SYSDK
//
//  Created by ls on 2017/11/29.
//  lsjy
//

#import "BGGDragButton.h"
#import "BGGPCH.h"
// 屏幕高度
#define ScreenH [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define ScreenW [UIScreen mainScreen].bounds.size.width

static CGFloat buttonAlpha = 0.5;
static CGFloat floatSize = 45;/**悬浮按钮大小<*/

@implementation SYFloatWindow
//- (void)layoutSubviews {
//    self.frame = _floatFrame;
//}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return  UIInterfaceOrientationMaskAllButUpsideDown;
//}
@end


@interface BGGDragButton()

/**
 *  开始按下的触点坐标
 */
@property (nonatomic, assign)CGPoint startPos;

//@property (nonatomic,assign) BOOL isRotate;
@property(assign,nonatomic)UIInterfaceOrientation orgorientation;
@property (nonatomic,assign) CGPoint endCenter;
@property (nonatomic,assign) CGPoint currentPoint;
@property (nonatomic,assign) BOOL isDraging;
@property (nonatomic,assign)NSInteger flag;

@end

@implementation BGGDragButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
        // 悬浮按钮
       
        [self setBackgroundImage:[UIImage BGGGetImage:@"RHOFloat"] forState:UIControlStateNormal];
        // 按钮图片伸缩充满整个按钮
        self.imageView.contentMode = UIViewContentModeScaleToFill;
         CGSize size = keywindow.frame.size;
        self.frame = CGRectMake(0, 0, floatSize, floatSize);
        // 按钮点击事件
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
        
        // 初始选中状态
        self.selected = NO;
        // 禁止高亮
        self.adjustsImageWhenHighlighted = NO;
        self.rootView = keywindow;
        self.imageView.alpha = 0.8;
        self.backgroundColor = [UIColor clearColor];
        self.orgorientation = [UIApplication sharedApplication].statusBarOrientation;

        // 悬浮窗
        self.window = [[SYFloatWindow alloc]init];
        if (KIsIphone_X_series) {
                  self.window.frame = CGRectMake(size.width-floatSize-10, ScreenH/2.0-30, floatSize, floatSize);
              }else{
                  self.window.frame = CGRectMake(size.width-floatSize-10,ScreenH/2.0-30 , floatSize, floatSize);
              }

        self.window.windowLevel = UIWindowLevelNormal;
        self.window.backgroundColor =[UIColor clearColor];

        
        self.noticeLab = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 45, 20)];
        self.noticeLab.backgroundColor = Color_hex(@"#E72825");
        self.noticeLab.font = Font(11);
        self.noticeLab.textColor = Color_hex(@"#FFFFFF");
        self.noticeLab.textAlignment = NSTextAlignmentCenter;
        self.noticeLab.layer.cornerRadius = BGGCornerRadius;
        self.noticeLab.layer.masksToBounds = YES;
        self.noticeLab.text = @"新消息";
        self.noticeLab.hidden = YES;
        
        //将按钮添加到悬浮按钮上
        [self.window addSubview:self];
        [self.window addSubview:self.noticeLab];
        self.alpha = buttonAlpha;
        //    显示window
        [self.window makeKeyAndVisible];
        
     
      

        
    }
    return self;
}







// 枚举四个吸附方向
typedef enum {
    LEFT,
    RIGHT,
    TOP,
    BOTTOM
}Dir;

/**
 *  开始触摸，记录触点位置用于判断是拖动还是点击
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    // 获得触摸在根视图中的坐标
    UITouch *touch = [touches anyObject];
    _startPos = [touch locationInView:_rootView];
    self.alpha = 1;
    self.isDraging = YES;
}

/**
 *  手指按住移动过程,通过悬浮按钮的拖动事件来拖动整个悬浮窗口
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    // 获得触摸在根视图中的坐标
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:self.rootView];
    
    
    // 移动按钮到当前触摸位置
    self.superview.center = curPoint;//CGPointMake(self.superview.center.x, curPoint.y) ;
}



/**
 *  拖动结束后使悬浮窗口吸附在最近的屏幕边缘
 */
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 获得触摸在根视图中的坐标
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:_rootView];
    self.currentPoint = curPoint;
 
    CGRect rect = [self convertRect:self.frame toView:self.rootView];
    
    // 通知代理,如果结束触点和起始触点极近则认为是点击事件
    if (pow((_startPos.x - curPoint.x),2) + pow((_startPos.y - curPoint.y),2) < 1) {
        if ([BGGDataModel sharedInstance].isShowingRealName) {
            return;
        }
        
        [self.btnDelegate dragButtonClicked:self];
        // 点击后不吸附
        return;
    }
   
    [self performSelector:@selector(moveToSide) withObject:nil afterDelay:1];
   
   
  
}

-(void)moveToSide{
    CGFloat W = ScreenW;
    CGFloat H = ScreenH;
    
   
    
    // 与四个屏幕边界距离
    CGFloat left = self.currentPoint.x;
    CGFloat right = W - self.currentPoint.x-floatSize;

    
    // 计算四个距离最小的吸附方向
    Dir minDir = LEFT;
     self.noticeLab.frame = CGRectMake(35, 0, 45, 20);
    CGFloat minDistance = left;
    if (right < minDistance) {
        minDistance = right;
        minDir = RIGHT;
        self.noticeLab.frame = CGRectMake(-20, 0, 45, 20);
    }

    
   
    CGPoint endCenter = self.currentPoint;
    // 开始吸附
    switch (minDir) {
        case LEFT:
        {
         
            if (KIsIphone_X_series) {
                if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
                    endCenter = CGPointMake(0+40, self.currentPoint.y);
                }else{
                     endCenter = CGPointMake(0,self.currentPoint.y);
                }
                
            }else{
                endCenter = CGPointMake(0,self.currentPoint.y);
            }
            
            
          

            break;
        }
        case RIGHT:
        {
            if (KIsIphone_X_series) {
                if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) {
                    endCenter = CGPointMake(W-30, self.currentPoint.y);;
                }else{
                    endCenter = CGPointMake(W, self.currentPoint.y);
                }
                
            }else{
                endCenter = CGPointMake(W,self.currentPoint.y);
            }
            
           break;
        }

        default:{
            return;
        }
    }

    self.isDraging = NO;
    self.endCenter = endCenter;
    
    [self adsorption:nil];
}
- (void)adsorption:(NSValue *)value{
    if (self.isDraging) {
        return;
    }
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = buttonAlpha;
        self.window.center = self.endCenter;
       
    }];
}





@end

