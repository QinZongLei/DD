//
//  BGGView.m
//  LCPlayer
//
//  Created by liangrongchang on 2017/3/8.
//  Copyright © 2017年 Rochang. All rights reserved.
//

#import "BGGView.h"
#import "UIControl+Block.h"
#import "BGGPCH.h"
#import "UIBarButtonItem+Block.h"

@implementation BGGView

#pragma mark - UIView
+ (UIView *)viewWithFrame:(CGRect)frame color:(UIColor *)color {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

+ (UIView *)viewWithColor:(UIColor *)color {
    return [self viewWithFrame:CGRectZero color:color];
}

/** 创建 btn */
+ (BGGButton *)buttonWithTarget:(id)target sel:(SEL)sel action:(actionBlock)action {
    return [self buttonWithFrame:CGRectZero backImage:nil selBackImage:nil target:target sel:sel action:action];
}

/** 标题 */
+ (BGGButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor selTitle:(NSString *)selTitle selTitlecColor:(UIColor *)selTitleColor backColor:(UIColor *)backColor font:(UIFont *)font target:(id)target sel:(SEL)sel action:(actionBlock)action {
    return [self buttonWithFrame:frame titleColor:titleColor selTitleColor:selTitleColor backColor:backColor image:nil selImage:nil bgImage:nil bgSelImage:nil title:title selTitle:selTitle font:font target:target sel:sel action:action];
}
/** 图片 */
+ (BGGButton *)buttonWithFrame:(CGRect)frame image:(UIImage *)image selImage:(UIImage *)selImage target:(id)target sel:(SEL)sel action:(actionBlock)action {
    return [self buttonWithFrame:frame titleColor:nil selTitleColor:nil backColor:nil image:image selImage:selImage bgImage:nil bgSelImage:nil title:nil selTitle:nil font:nil target:target sel:sel action:action];
}
/** 背景图片 */
+ (BGGButton *)buttonWithFrame:(CGRect)frame backImage:(UIImage *)backImage selBackImage:(UIImage *)selBackImage target:(id)target sel:(SEL)sel action:(actionBlock)action {
    return [self buttonWithFrame:frame titleColor:nil selTitleColor:nil backColor:nil image:nil selImage:nil bgImage:backImage bgSelImage:selBackImage title:nil selTitle:nil font:nil target:target sel:sel action:action];
}
/** 图片 + 文字 */
+ (BGGButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor selTitle:(NSString *)selTitle selTitlecColor:(UIColor *)selTitleColor image:(UIImage *)image selImage:(UIImage *)selImage backColor:(UIColor *)backColor font:(UIFont *)font target:(id)target sel:(SEL)sel action:(actionBlock)action {
    return [self buttonWithFrame:frame titleColor:titleColor selTitleColor:selTitleColor backColor:backColor image:image selImage:selImage bgImage:nil bgSelImage:nil title:title selTitle:selTitle font:font target:target sel:sel action:action];
}

/** 背景 + 文字 */
+ (BGGButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor selTitle:(NSString *)selTitle selTitlecColor:(UIColor *)selTitleColor bgImage:(UIImage *)bgImage bgSelImage:(UIImage *)bgSelImage backColor:(UIColor *)backColor font:(UIFont *)font target:(id)target sel:(SEL)sel action:(actionBlock)action {
    return [self buttonWithFrame:frame titleColor:titleColor selTitleColor:selTitleColor backColor:backColor image:nil selImage:nil bgImage:bgImage bgSelImage:bgSelImage title:title selTitle:selTitle font:font target:target sel:sel action:action];
}

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
                       action:(actionBlock)action {
    BGGButton *button = [[BGGButton alloc] initWithFrame:frame];
    if (title.length) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (selTitle) {
        [button setTitle:selTitle forState:UIControlStateSelected];
    }
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (selTitleColor) {
        [button setTitleColor:selTitleColor forState:UIControlStateSelected];
    }
    if (backColor) {
        button.backgroundColor = backColor;
    }
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    if (selImage) {
        [button setImage:selImage forState:UIControlStateSelected];
    }
    if (bgImage) {
        [button setBackgroundImage:bgImage forState:UIControlStateNormal];
    }
    if (bgsSelImage) {
        [button setBackgroundImage:bgsSelImage forState:UIControlStateSelected];
    }
    if (font) {
        button.titleLabel.font = font;
    }
    if (sel) {
        [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    }
    if (action && !sel) {
       // [button addAction:action forControlEvents:UIControlEventTouchUpInside];
    }
    button.adjustsImageWhenHighlighted = NO;
    button.highlighted = NO;
    return button;
}



#pragma mark - UIlabel
+ (UILabel *)labelWithFrame:(CGRect)frame textColor:(UIColor *)textColor backColor:(UIColor *)backColor textAlignment:(NSTextAlignment)textAlignment lineNumber:(NSInteger)number text:(NSString *)text font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
//    label.adjustsFontSizeToFitWidth = YES;
    if (text.length) {
        label.text = text;
    }
    if(textColor) {
        label.textColor = textColor;
    }
    if (backColor) {
        label.backgroundColor = backColor;
    }
    label.textAlignment = textAlignment;
    label.numberOfLines = number;
    if (font) {
        label.font = font;
    }
    return label;
}

+ (UILabel *)labelWithTextColor:(UIColor *)textColor backColor:(UIColor *)backColor textAlignment:(NSTextAlignment)textAlignment lineNumber:(NSInteger)number text:(NSString *)text font:(UIFont *)font {
    return [self labelWithFrame:CGRectZero textColor:textColor backColor:backColor textAlignment:textAlignment lineNumber:number text:text font:font];
}


#pragma mark - Tableview
+ (UITableView *)tableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style dataSource:(id<UITableViewDataSource>)dataSource delegate:(id<UITableViewDelegate>)delegate showHorizontal:(BOOL)showH showVertical:(BOOL)showV backColor:(UIColor *)backColor footerView:(UIView *)footerView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:style];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (backColor) {
        tableView.backgroundColor = backColor;
    }
    if (footerView) {
        tableView.tableFooterView = footerView;
    }
    tableView.dataSource = dataSource;
    tableView.delegate = delegate;
    tableView.showsHorizontalScrollIndicator = showH;
    tableView.showsVerticalScrollIndicator = showV;
    return tableView;
}

+ (UITableView *)tableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style dataSource:(id<UITableViewDataSource>)dataSource delegate:(id<UITableViewDelegate>)delegate {
    return [self tableViewWithFrame:frame style:style dataSource:dataSource delegate:delegate showHorizontal:YES showVertical:YES backColor:nil footerView:[[UIView alloc] init]];
}

+ (UITableView *)tableViewWithStyle:(UITableViewStyle)style dataSource:(id<UITableViewDataSource>)dataSource delegate:(id<UITableViewDelegate>)delegate {
    return [self tableViewWithFrame:CGRectZero style:style dataSource:dataSource delegate:delegate showHorizontal:YES showVertical:YES backColor:nil footerView:[[UIView alloc] init]];
}

#pragma mark - UIScrollview
+ (UIScrollView *)scrollViewWithFrame:(CGRect)frame delegate:(id<UIScrollViewDelegate>)delegete showsHorizontal:(BOOL)horizontal showVertical:(BOOL)vertical pagingEnable:(BOOL)page bounces:(BOOL)bounces backColor:(UIColor *)backColor {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.delegate = delegete;
    scrollView.showsHorizontalScrollIndicator = horizontal;
    scrollView.showsVerticalScrollIndicator = vertical;
    scrollView.pagingEnabled = page;
    scrollView.bounces = bounces;
    if (backColor) {
        scrollView.backgroundColor = backColor;
    }
    return scrollView;
}

+ (UIScrollView *)scrollViewWithFrame:(CGRect)frame delegate:(id<UIScrollViewDelegate>)delegete {
    return [self scrollViewWithFrame:frame delegate:delegete showsHorizontal:YES showVertical:YES pagingEnable:NO bounces:YES backColor:nil];
}

+ (UIScrollView *)scrollViewWithDelegate:(id<UIScrollViewDelegate>)delegete {
    return [self scrollViewWithFrame:CGRectZero delegate:delegete];
}

#pragma mark - UICollectView
+ (UICollectionView *)collectionViewWithFrame:(CGRect)frame layout:(UICollectionViewFlowLayout *)layout direction:(UICollectionViewScrollDirection)direction minInterSpace:(CGFloat)interSpace minLineSpace:(CGFloat)lineSpace delegate:(id<UICollectionViewDelegate>)delegate dataSource:(id<UICollectionViewDataSource>)dataSource showHorizontal:(BOOL)showH showVertical:(BOOL)showV pagingEnabled:(BOOL)page backColor:(UIColor *)color {
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    layout.minimumInteritemSpacing = interSpace;
    layout.minimumLineSpacing = lineSpace;
    layout.scrollDirection = direction;
    collectionView.delegate = delegate;
    collectionView.dataSource = dataSource;
    collectionView.showsHorizontalScrollIndicator = showH;
    collectionView.showsVerticalScrollIndicator = showV;
    collectionView.pagingEnabled = page;
    if (color) {
        collectionView.backgroundColor = color;
    }
    return collectionView;
}

+ (UICollectionView *)collectionViewWithFrame:(CGRect)frame layout:(UICollectionViewFlowLayout *)layout direction:(UICollectionViewScrollDirection)direction minInterSpace:(CGFloat)interSpace minLineSpace:(CGFloat)lineSpace delegate:(id<UICollectionViewDelegate>)delegate dataSource:(id<UICollectionViewDataSource>)dataSource backColor:(UIColor *)color {
    return [self collectionViewWithFrame:frame layout:layout direction:direction minInterSpace:interSpace minLineSpace:lineSpace delegate:delegate dataSource:dataSource showHorizontal:YES showVertical:YES pagingEnabled:YES backColor:color];
}

+ (UICollectionView *)collectionViewWithLayout:(UICollectionViewFlowLayout *)layout direction:(UICollectionViewScrollDirection)direction minInterSpace:(CGFloat)interSpace minLineSpace:(CGFloat)lineSpace delegate:(id<UICollectionViewDelegate>)delegate dataSource:(id<UICollectionViewDataSource>)dataSource backColor:(UIColor *)color {
    return [self collectionViewWithFrame:CGRectZero layout:layout direction:direction minInterSpace:interSpace minLineSpace:lineSpace delegate:delegate dataSource:dataSource backColor:color];
}

#pragma mark - UIImageView
+ (UIImageView *)imageViewWithFrame:(CGRect)frame image:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    if (image) {
        imageView.image = image;
    }
    return imageView;
}

+ (UIImageView *)imageViewWithImage:(UIImage *)image {
    return [self imageViewWithFrame:CGRectZero image:image];
}

#pragma mark - UITextField
+ (UITextField *)textFieldWithFrame:(CGRect)frame textColor:(UIColor *)textColor backColor:(UIColor *)backColor placeTitle:(NSString *)placeTitle font:(UIFont *)font {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.placeholder = placeTitle;
    textField.backgroundColor = backColor;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    if (textColor) {
        textField.textColor = textColor;
    }
    if (font) {
        textField.font = font;
    } else {
        textField.font = Font(17);
    }
    return textField;
}

+ (UITextField *)textFieldWithTextColor:(UIColor *)textColor backColor:(UIColor *)backColor placeTitle:(NSString *)placeTitle font:(UIFont *)font {
    return [self textFieldWithFrame:CGRectZero textColor:textColor backColor:backColor placeTitle:placeTitle font:font];
}

#pragma mark - UITextView
+ (UITextView *)textViewWithFrame:(CGRect)frame backColor:(UIColor *)color font:(UIFont *)font delegate:(id<UITextViewDelegate>)delegate{
    UITextView *textView = [[UITextView alloc] initWithFrame:frame];
    textView.delegate = delegate;
    textView.backgroundColor = color;
    textView.font = font;
    //    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:@{NSFontAttributeName : font}];
    return textView;
}

+ (UITextView *)textViewWithBackColor:(UIColor *)color font:(UIFont *)font delegate:(id<UITextViewDelegate>)delegate {
    return [self textViewWithFrame:CGRectZero backColor:color font:font delegate:delegate];
}

#pragma mark - UIBarButtonItem
+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image target:(id)target sel:(SEL)sel action:(actionBlock)action {
    if (sel) {
        return [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:target action:sel];
    } else {
        return [[UIBarButtonItem alloc] initWithImage:image action:action];
    }
}

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title target:(id)target sel:(SEL)sel action:(actionBlock)action {
    if (sel) {
        return [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:sel];
    } else {
        return [[UIBarButtonItem alloc] initWithTitle:title action:action];
    }
}

#pragma mark - UITapGestureRecognizer
+ (UITapGestureRecognizer *)tapWithTarget:(id)target action:(SEL)action {
    return [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    
}

#pragma mark - UIProgressView
+ (UIProgressView *)progressViewWithFrame:(CGRect)frame trackTintColor:(UIColor *)tintColor progressColor:(UIColor *)progressColor {
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:frame];
    progressView.trackTintColor = tintColor;
    progressView.progressTintColor = progressColor;
    return progressView;
}

#pragma mark - UISlider
+ (UISlider *)sliderWithFrame:(CGRect)frame thumbImage:(NSString *)image minColor:(UIColor *)minColor maxColor:(UIColor *)maxColor {
    UISlider *slider = [[UISlider alloc] initWithFrame:frame];
    slider.minimumTrackTintColor = minColor;
    slider.maximumTrackTintColor = maxColor;
    if (image.length) {
        [slider setThumbImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    return slider;
}

@end
