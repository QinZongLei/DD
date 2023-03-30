//
//  NSObject+BGGHUD.h
//  BGGSDK
//
//  Created by lisheng on 2021/5/26.
//  Copyright © 2021 BGG. All rights reserved.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (BGGHUD)
-(void)popNotice:(NSString *)notice afterTime:(NSInteger )time;
-(void)popNotice:(NSString *)notice;
-(void)popLoadingView:(NSString *)hint;
-(void)popLoadingView:(NSString *)hint afterTime:(NSInteger )time;
- (void)hideNotice;

-(BOOL)isFirstLoginToday;

@end

NS_ASSUME_NONNULL_END
