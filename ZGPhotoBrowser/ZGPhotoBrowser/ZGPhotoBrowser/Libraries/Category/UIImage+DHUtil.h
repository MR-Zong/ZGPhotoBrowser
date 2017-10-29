//
//  DHImage.h
//  hongshuishi
//
//  Created by Dragon on 15/4/3.
//  Copyright (c) 2015年 kg. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIImage (DHUtil)

+ (id)imageFromColor:(UIColor *)color;
+ (id)imageFromColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)subImageWithRect:(CGRect)rect;

+ (UIImage *)imageWithSize:(CGSize)size
                     color:(UIColor *)color
              cornerRadius:(float)cornerRadius
                 lineWidth:(CGFloat)lineWidth
               strokeColor:(UIColor *)strokeColor;

+ (UIImage *)fixOrientation:(UIImage *)aImage;

@end
