//
//  BGGView.h
//  LCPlayer
//
//  Created by liangrongchang on 2017/3/8.
//  Copyright © 2017年 Rochang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BGGButton.h"

typedef void(^actionBlock)(id sender);

@interface BGGView : NSObject

+ (UIView *)viewWithFrame:(CGRect)frame color:(UIColor *)color;
+ (UIView *)viewWithColor:(UIColor *)color;

/** 创建btn */
+ (BGGButton *)buttonWithTarget:(id)target sel:(SEL)sel action:(actionBlock)action;

/** 标题 */
+ (BGGButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor selTitle:(NSString *)selTitle selTitlecColor:(UIColor *)selTitleColor backColor:(UIColor *)backColor font:(UIFont *)font target:(id)target sel:(SEL)sel action:(actionBlock)action;

/** 图片 */
+ (BGGButton *)buttonWithFrame:(CGRect)frame image:(UIImage *)image selImage:(UIImage *)selImage target:(id)target sel:(SEL)sel action:(actionBlock)action;

/** 背景图片 */
+ (BGGButton *)buttonWithFrame:(CGRect)frame backImage:(UIImage *)backImage selBackImage:(UIImage *)selBackImage target:(id)target sel:(SEL)sel action:(actionBlock)action;

/** 图片 + 文字 */
+ (BGGButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor selTitle:(NSString *)selTitle selTitlecColor:(UIColor *)selTitleColor image:(UIImage *)image selImage:(UIImage *)selImage backColor:(UIColor *)backColor font:(UIFont *)font target:(id)target sel:(SEL)sel action:(actionBlock)action;

/** 背景图片 + 文字 */
+ (BGGButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor selTitle:(NSString *)selTitle selTitlecColor:(UIColor *)selTitleColor bgImage:(UIImage *)bgImage bgSelImage:(UIImage *)bgSelImage backColor:(UIColor *)backColor font:(UIFont *)font target:(id)target sel:(SEL)sel action:(actionBlock)action;

#pragma mark - UIButton
/** 多项 */
+ (BGGButton *)buttonWithFrame:(CGRect)frame
                   titleColor:(UIColor *)titleColor
                selTitleColor:(UIColor *)selTitleColor
                    backColor:(UIColor *)backColor
                        image:(UIImage *)image
                     selImage:(UIImage *)selImage
                      bgImage:(UIImage *)bgImage
                   bgSelImage:(UIImage *)bgsSelImage
                        title:(NSString *)title
                     selTitle:(NSString *)selTitle
                     font:(UIFont *)font
                       target:(id)target
                          sel:(SEL)sel
                       action:(actionBlock)action;


#pragma mark - UIlabel
/** 多项 */
+ (UILabel *)labelWithFrame:(CGRect)frame
                  textColor:(UIColor *)textColor
                  backColor:(UIColor *)backColor
              textAlignment:(NSTextAlignment)textAlignment
                 lineNumber:(NSInteger)number
                       text:(NSString *)text
                       font:(UIFont *)font;

+ (UILabel *)labelWithTextColor:(UIColor *)textColor
                  backColor:(UIColor *)backColor
              textAlignment:(NSTextAlignment)textAlignment
                 lineNumber:(NSInteger)number
                       text:(NSString *)text
                       font:(UIFont *)font;

#pragma mark - Tableview
/** tableView 多项 */
+ (UITableView *)tableViewWithFrame:(CGRect)frame
                              style:(UITableViewStyle)style
                         dataSource:(id<UITableViewDataSource>)dataSource
                           delegate:(id<UITableViewDelegate>)delegate
                     showHorizontal:(BOOL)showH
                       showVertical:(BOOL)showV
                          backColor:(UIColor *)backColor
                         footerView:(UIView *)footerView;

/** 简单 */
+ (UITableView *)tableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style dataSource:(id<UITableViewDataSource>)dataSource delegate:(id<UITableViewDelegate>)delegate;

+ (UITableView *)tableViewWithStyle:(UITableViewStyle)style dataSource:(id<UITableViewDataSource>)dataSource delegate:(id<UITableViewDelegate>)delegate;

#pragma mark - UIScrollview
/** 多项 */
+ (UIScrollView *)scrollViewWithFrame:(CGRect)frame
                             delegate:(id<UIScrollViewDelegate>)delegete
                      showsHorizontal:(BOOL)horizontal
                         showVertical:(BOOL)vertical
                         pagingEnable:(BOOL)page
                              bounces:(BOOL)bounces
                            backColor:(UIColor *)backColor;

/** 简单 */
+ (UIScrollView *)scrollViewWithFrame:(CGRect)frame delegate:(id<UIScrollViewDelegate>)delegete;

+ (UIScrollView *)scrollViewWithDelegate:(id<UIScrollViewDelegate>)delegete;

#pragma mark - UICollectView
/** 多项 */
+ (UICollectionView *)collectionViewWithFrame:(CGRect)frame
                                       layout:(UICollectionViewFlowLayout *)layout
                                    direction:(UICollectionViewScrollDirection)direction
                                minInterSpace:(CGFloat)interSpace
                                 minLineSpace:(CGFloat)lineSpace
                                     delegate:(id<UICollectionViewDelegate>)delegate
                                   dataSource:(id<UICollectionViewDataSource>)dataSource
                               showHorizontal:(BOOL)showH
                                 showVertical:(BOOL)showV
                                pagingEnabled:(BOOL)page
                                    backColor:(UIColor *)color;

/** 简单 */
+ (UICollectionView *)collectionViewWithFrame:(CGRect)frame layout:(UICollectionViewFlowLayout *)layout direction:(UICollectionViewScrollDirection)direction minInterSpace:(CGFloat)interSpace minLineSpace:(CGFloat)lineSpace delegate:(id<UICollectionViewDelegate>)delegate dataSource:(id<UICollectionViewDataSource>)dataSource backColor:(UIColor *)color;

+ (UICollectionView *)collectionViewWithLayout:(UICollectionViewFlowLayout *)layout direction:(UICollectionViewScrollDirection)direction minInterSpace:(CGFloat)interSpace minLineSpace:(CGFloat)lineSpace delegate:(id<UICollectionViewDelegate>)delegate dataSource:(id<UICollectionViewDataSource>)dataSource backColor:(UIColor *)color;

#pragma mark - UITextField
+ (UITextField *)textFieldWithFrame:(CGRect)frame textColor:(UIColor *)textColor backColor:(UIColor *)backColor placeTitle:(NSString *)placeTitle font:(UIFont *)font;


+ (UITextField *)textFieldWithTextColor:(UIColor *)textColor backColor:(UIColor *)backColor placeTitle:(NSString *)placeTitle font:(UIFont *)font;

#pragma mark - UIImageView
+ (UIImageView *)imageViewWithFrame:(CGRect)frame
                              image:(UIImage *)image;

+ (UIImageView *)imageViewWithImage:(UIImage *)image;

#pragma mark - UITextView
+ (UITextView *)textViewWithFrame:(CGRect)frame
                        backColor:(UIColor *)color
                             font:(UIFont *)font
                         delegate:(id<UITextViewDelegate>)delegate;

+ (UITextView *)textViewWithBackColor:(UIColor *)color
                             font:(UIFont *)font
                         delegate:(id<UITextViewDelegate>)delegate;

#pragma mark - UIBarButtonItem
+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image target:(id)target sel:(SEL)sel action:(actionBlock)action;

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title target:(id)target sel:(SEL)sel action:(actionBlock)action;

#pragma mark - UITapGestureRecognizer
+ (UITapGestureRecognizer *)tapWithTarget:(id)target action:(SEL)action;

#pragma mark - UIProgressView
+ (UIProgressView *)progressViewWithFrame:(CGRect)frame trackTintColor:(UIColor *)tintColor progressColor:(UIColor *)progressColor;

#pragma mark - UISlider
+ (UISlider *)sliderWithFrame:(CGRect)frame thumbImage:(NSString *)image minColor:(UIColor *)minColor maxColor:(UIColor *)maxColor;
@end
