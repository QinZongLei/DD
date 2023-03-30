//
//  BGGLogionView.h
//  BGGSDK
//
//  Created by lisheng on 2021/5/25.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGMainBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BGGLogionView : BGGMainBaseView

@property(nonatomic,strong)UIView *phoneBackView;
-(void)checkIFAccountLogin;
@end

NS_ASSUME_NONNULL_END
