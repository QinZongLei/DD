/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 * (c) Laurin Brandner
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImage+GIF.h"
#import "SDWebImageGIFCoder.h"
#import "NSImage+WebCache.h"

@implementation UIImage (GIF)

+ (UIImage *)sd_animatedGIFNamed:(NSString *)name {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle bundleWithURL:kGetBundle pathForResource:name ofType:@"gif"]];
    return [UIImage sd_animatedGIFWithData:data];
}

+ (UIImage *)sd_animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    return [[SDWebImageGIFCoder sharedCoder] decodedImageWithData:data];
}

- (BOOL)isGIF {
    return (self.images != nil);
}

@end
