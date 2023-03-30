//
//  BGGAntiAddictionView.h
//  BGGSDK
//
//  Created by 李胜 on 2021/6/3.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGMainBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BGGAntiAddictionView : BGGMainBaseView
@property(nonatomic,assign)BOOL continueGame;
@property(nonatomic,assign)BOOL isKnowm;
@property(nonatomic,strong)NSString *msg;
@end

NS_ASSUME_NONNULL_END
