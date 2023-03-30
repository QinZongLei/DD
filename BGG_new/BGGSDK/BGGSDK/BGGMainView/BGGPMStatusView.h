//
//  BGGPMStatusView.h
//  BGGSDK
//
//  Created by 李胜 on 2021/7/15.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGMainBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BGGPMStatusView : BGGMainBaseView
@property(nonatomic,assign)NSInteger pmType;
@property(nonatomic,strong)UILabel *statuLab;
@property(nonatomic,strong)UILabel *orderNumLab;
@end

NS_ASSUME_NONNULL_END
