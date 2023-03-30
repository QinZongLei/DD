//
//  UILabel+LC.m
//  Unicorn_iOS_OC
//
//  Created by Qz on 2019/1/15.
//  Copyright © 2019 Liangrc. All rights reserved.
//

#import "UILabel+LC.h"

@implementation UILabel (LC)

- (void)lc_setFont:(UIFont *)font text:(NSString *)text {
    NSDictionary *dict = @{NSFontAttributeName : font};
    self.attributedText = [self attrStrWithDict:dict text:text];
}

- (void)lc_setColor:(UIColor *)color text:(NSString *)text {
    NSDictionary *dict = @{NSForegroundColorAttributeName : color};
    self.attributedText = [self attrStrWithDict:dict text:text];
}

- (void)lc_setColor:(UIColor *)color texts:(NSArray<NSString *> *)texts {
    NSDictionary *dict = @{NSForegroundColorAttributeName : color};
    self.attributedText = [self attrStrWithDict:dict texts:texts];
}

- (void)lc_setTextSpace:(CGFloat)space text:(NSString *)text {
    NSDictionary *dict = @{NSKernAttributeName : @(space)};
    self.attributedText = [self attrStrWithDict:dict text:text];
}

- (void)lc_setthroughLineColor:(UIColor *)color text:(NSString *)text {
    NSDictionary *dict = @{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle),
                           NSStrikethroughColorAttributeName : color
                          
                           };
    self.attributedText = [self attrStrWithDict:dict text:text];
}

- (void)lc_setUnderLineColor:(UIColor *)color text:(NSString *)text {
    NSDictionary *dict = @{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
                           NSUnderlineColorAttributeName : color,
                           NSForegroundColorAttributeName : color
                           };
    self.attributedText = [self attrStrWithDict:dict text:text];
}

- (void)lc_setLineSpace:(CGFloat)lineSpace interItemSpace:(CGFloat)itemSpace text:(NSString *)text {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    if (lineSpace) paragraphStyle.lineSpacing = lineSpace;
    if (itemSpace) paragraphStyle.paragraphSpacing = itemSpace;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *dict = @{NSParagraphStyleAttributeName : paragraphStyle};
    self.attributedText = [self attrStrWithDict:dict text:text];
}

#pragma mark - 富文本
- (NSMutableAttributedString *)attrStrWithDict:(NSDictionary *)dict texts:(NSArray<NSString *> *)texts {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.text];
    [texts enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange rang = [self.text rangeOfString:obj];
        [attrStr addAttributes:dict range:rang];
    }];
    return attrStr;
}

- (NSMutableAttributedString *)attrStrWithDict:(NSDictionary *)dict text:(NSString *)text {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSRange rang = [self.text rangeOfString:text];
    [attrStr addAttributes:dict range:rang];
    return attrStr;
}

- (NSUInteger)lc_linesWithWidth:(CGFloat)width {
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    NSDictionary *attrs = @{ NSFontAttributeName : self.font};
    CGFloat textH = [self.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:opts attributes:attrs context:nil].size.height;
    CGFloat lineHeight = self.font.lineHeight;
    return textH / lineHeight;
}

@end
