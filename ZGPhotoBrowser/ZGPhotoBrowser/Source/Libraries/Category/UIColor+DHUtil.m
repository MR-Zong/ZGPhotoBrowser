//
//  DHColor.m
//  hongshuishi
//
//  Created by Dragon on 15/4/3.
//  Copyright (c) 2015年 kg. All rights reserved.
//

#import "UIColor+DHUtil.h"

void HSL2RGB(float h, float s, float l, float* outR, float* outG, float* outB)
{
    float			temp1,
    temp2;
    float			temp[3];
    int				i;
    
    // Check for saturation. If there isn't any just return the luminance value for each, which results in gray.
    if(s == 0.0) {
        if(outR)
            *outR = l;
        if(outG)
            *outG = l;
        if(outB)
            *outB = l;
        return;
    }
    
    // Test for luminance and compute temporary values based on luminance and saturation
    if(l < 0.5)
        temp2 = l * (1.0 + s);
    else
        temp2 = l + s - l * s;
    temp1 = 2.0 * l - temp2;
    
    // Compute intermediate values based on hue
    temp[0] = h + 1.0 / 3.0;
    temp[1] = h;
    temp[2] = h - 1.0 / 3.0;
    
    for(i = 0; i < 3; ++i) {
        
        // Adjust the range
        if(temp[i] < 0.0)
            temp[i] += 1.0;
        if(temp[i] > 1.0)
            temp[i] -= 1.0;
        
        
        if(6.0 * temp[i] < 1.0)
            temp[i] = temp1 + (temp2 - temp1) * 6.0 * temp[i];
        else {
            if(2.0 * temp[i] < 1.0)
                temp[i] = temp2;
            else {
                if(3.0 * temp[i] < 2.0)
                    temp[i] = temp1 + (temp2 - temp1) * ((2.0 / 3.0) - temp[i]) * 6.0;
                else
                    temp[i] = temp1;
            }
        }
    }
    
    // Assign temporary values to R, G, B
    if(outR)
        *outR = temp[0];
    if(outG)
        *outG = temp[1];
    if(outB)
        *outB = temp[2];
}


void RGB2HSL(float r, float g, float b, float* outH, float* outS, float* outL)
{
    /*r = r/255.0f;
     g = g/255.0f;
     b = b/255.0f;*/
    
    
    float h,s, l, v, m, vm, r2, g2, b2;
    
    h = 0;
    s = 0;
    l = 0;
    
    v = MAX(r, g);
    v = MAX(v, b);
    m = MIN(r, g);
    m = MIN(m, b);
    
    l = (m+v)/2.0f;
    
    if (l <= 0.0){
        if(outH)
            *outH = h;
        if(outS)
            *outS = s;
        if(outL)
            *outL = l;
        return;
    }
    
    vm = v - m;
    s = vm;
    
    if (s > 0.0f){
        s/= (l <= 0.5f) ? (v + m) : (2.0 - v - m);
    }else{
        if(outH)
            *outH = h;
        if(outS)
            *outS = s;
        if(outL)
            *outL = l;
        return;
    }
    
    r2 = (v - r)/vm;
    g2 = (v - g)/vm;
    b2 = (v - b)/vm;
    
    if (r == v){
        h = (g == m ? 5.0f + b2 : 1.0f - g2);
    }else if (g == v){
        h = (b == m ? 1.0f + r2 : 3.0 - b2);
    }else{
        h = (r == m ? 3.0f + g2 : 5.0f - r2);
    }
    
    h/=6.0f;
    
    if(outH)
        *outH = h;
    if(outS)
        *outS = s;
    if(outL)
        *outL = l;
    
}


@implementation UIColor(DHUtil)

+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

+ (UIColor*) colorWithHex:(NSInteger)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    if (stringToConvert == nil || stringToConvert.length == 0) {
        return nil;
    }
    
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString hasPrefix:@"#"] == YES && cString.length < 7) {
        return nil;
    }
    
    if ([cString hasPrefix:@"0X"] == YES && cString.length < 8) {
        return nil;
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    } else {
        if ([cString hasPrefix:@"0X"]) {
            cString = [cString substringFromIndex:2];
        }
    }
    
    if (cString.length != 6 && cString.length != 8) {
        return nil;
    }
    
    unsigned int r = 0, g = 0, b = 0, a = 1.0f;
    
    // Separate into r, g, b substrings
    NSRange range = NSMakeRange(0, 0);
    range.length = 2;
    
    range.location = 0;
    NSString *rString = [cString substringWithRange:range];
    [[NSScanner scannerWithString:rString] scanHexInt:&r];// Scan values
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    // #000000ff
    // 0x000000ff
    if (bString.length == 8) {
        range.location = 6;
        NSString *aString = [cString substringWithRange:range];
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
    }
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:a];
}


@end
