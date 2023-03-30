//
//  BGGButton.m
//  Unicorn_iOS_OC
//
//  Created by Qz on 2019/1/11.
//  Copyright © 2019 Liangrc. All rights reserved.
//

#import "BGGButton.h"
#import "UIView+LCLayout.h"

@implementation BGGButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData {
    _spacing = 4;
    _imageRadius = 0;
    _type = BGGButtonTypeImageNone;
}

#pragma mark - 布局
- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.titleLabel.text.length) {
        _spacing = 0;
    }
    [self.titleLabel sizeToFit];
    self.imageView.size_gs = CGSizeEqualToSize(self.imageSize, CGSizeZero) ? self.imageView.image.size : self.imageSize;
    
    switch (_type) {
        case BGGButtonTypeImageLeft:{ // 左
            self.imageView.x_gs = (self.width_gs - self.titleLabel.width_gs - self.spacing - self.imageView.width_gs) / 2;
            self.titleLabel.x_gs = self.spacing + self.imageView.right_W_gs;
            self.imageView.centerY_gs = self.titleLabel.centerY_gs = self.height_gs / 2;
        }
            break;
        case BGGButtonTypeImageRight:{ // 右
            self.titleLabel.x_gs = (self.width_gs - self.titleLabel.width_gs - self.spacing - self.imageView.width_gs) / 2;
            self.imageView.x_gs = self.titleLabel.right_W_gs + self.spacing;
            self.titleLabel.centerY_gs = self.imageView.centerY_gs = self.height_gs / 2;
        }
            break;
        case BGGButtonTypeImageTop:{ // 上
            self.imageView.y_gs = (self.height_gs - self.imageView.height_gs  - self.titleLabel.height_gs  - self.spacing) / 2;
            self.titleLabel.y_gs = self.imageView.bottom_H_gs + self.spacing;
            self.titleLabel.centerX_gs = self.imageView.centerX_gs = self.width_gs / 2;
        }
            break;
        case BGGButtonTypeImageBottom:{ // 下
            self.titleLabel.y_gs = (self.height_gs - self.imageView.height_gs  - self.titleLabel.height_gs  - self.spacing) / 2;
            self.imageView.y_gs = self.titleLabel.bottom_H_gs + self.spacing;
            self.titleLabel.centerX_gs = self.imageView.centerX_gs = self.width_gs / 2;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - setter
- (void)setType:(BGGButtonType)type {
    _type = type;
    [self setNeedsLayout];
}

- (void)setSpacing:(CGFloat)spacing {
    _spacing = spacing;
    [self setNeedsLayout];
}

- (void)setImageRadius:(CGFloat)imageRadius {
    _imageRadius = imageRadius;
    [self setNeedsLayout];
}

- (void)setImageSize:(CGSize)imageSize {
    _imageSize = imageSize;
    [self setNeedsLayout];
}

- (void)lc_setUnderLineColor:(UIColor *)color text:(NSString *)text {
    NSDictionary *dict = @{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
                           NSUnderlineColorAttributeName : color
                           };
    self.titleLabel.attributedText = [self attrStrWithDict:dict text:text];
}

- (void)lc_setLineSpace:(CGFloat)lineSpace interItemSpace:(CGFloat)itemSpace text:(NSString *)text {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    if (lineSpace) paragraphStyle.lineSpacing = lineSpace;
    if (itemSpace) paragraphStyle.paragraphSpacing = itemSpace;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *dict = @{NSParagraphStyleAttributeName : paragraphStyle};
    self.titleLabel.attributedText = [self attrStrWithDict:dict text:text];
}

#pragma mark - 富文本
- (NSMutableAttributedString *)attrStrWithDict:(NSDictionary *)dict texts:(NSArray<NSString *> *)texts {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
    [texts enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange rang = [self.titleLabel.text rangeOfString:obj];
        [attrStr addAttributes:dict range:rang];
    }];
    return attrStr;
}

- (NSMutableAttributedString *)attrStrWithDict:(NSDictionary *)dict text:(NSString *)text {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
    NSRange rang = [self.titleLabel.text rangeOfString:text];
    [attrStr addAttributes:dict range:rang];
    return attrStr;
}

- (NSUInteger)lc_linesWithWidth:(CGFloat)width {
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    NSDictionary *attrs = @{ NSFontAttributeName : self.titleLabel.font};
    CGFloat textH = [self.titleLabel.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:opts attributes:attrs context:nil].size.height;
    CGFloat lineHeight = self.titleLabel.font.lineHeight;
    return textH / lineHeight;
}

@end
