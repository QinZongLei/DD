//
//  BGGWKWebview.h
//  BGGSDK
//
//  Created by 李胜 on 2021/5/28.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGMainBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BGGWKWebview : BGGMainBaseView
@property(nonatomic,strong)NSString *webUrl;
@property(nonatomic,strong)NSDictionary *paramDic;
@property(nonatomic,assign)BOOL isPM;
@end

NS_ASSUME_NONNULL_END
