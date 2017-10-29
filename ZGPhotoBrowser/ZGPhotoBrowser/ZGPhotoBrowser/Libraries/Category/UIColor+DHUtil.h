//
//  DHColor.h
//  hongshuishi
//
//  Created by Dragon on 15/4/3.
//  Copyright (c) 2015年 kg. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBA(r,g,b,a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]


//HSL 和 RGB互换
void HSL2RGB(float h, float s, float l, float* outR, float* outG, float* outB);
void RGB2HSL(float r, float g, float b, float* outH, float* outS, float* outL);

@interface UIColor(DHUtil)

+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*) colorWithHex:(NSInteger)hexValue;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

@end
