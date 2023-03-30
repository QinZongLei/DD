//
//  BGGBackButton.h
//  NEWXLS_Game_MDFZ
//
//  Created by 卢祥庭 on 2018/4/17.
//  Copyright © 2018年 sy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    kNEWXLS_BackButtonStyleGray,
    kNEWXLS_BackButtonStyleOrange
    
}   kNEWXLS_BackButtonStyle;


@interface BGGBackButton : UIButton

- (void)setStyle:(kNEWXLS_BackButtonStyle)style;

@end
