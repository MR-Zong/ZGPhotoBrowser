//
//  DHImage.m
//  hongshuishi
//
//  Created by Dragon on 15/4/3.
//  Copyright (c) 2015年 kg. All rights reserved.
//

#import "UIImage+DHUtil.h"

@implementation UIImage (DHUtil)

+ (id)imageFromColor:(UIColor *)color
{
    return [self imageFromColor:color size:CGSizeMake(1, 1)];
}

+ (id)imageFromColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;

}

-(UIImage *)subImageWithRect:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

+ (UIImage *)imageWithSize:(CGSize)size
                     color:(UIColor *)color
              cornerRadius:(float)cornerRadius
                 lineWidth:(CGFloat)lineWidth
               strokeColor:(UIColor *)strokeColor
{
    UIGraphicsBeginImageContext(size);
    
    // 绘图
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 抗锯齿
    CGContextSetAllowsAntialiasing(context, true);
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    //    CGContextMoveToPoint(context, width * 0.5, 0.0);
    //    CGContextAddLineToPoint(context, imgSize.width, width * 0.5);
    //    CGContextAddLineToPoint(context, imgSize.width, imgSize.height);
    //    CGContextAddLineToPoint(context, 0.0, imgSize.height);
    //    CGContextAddLineToPoint(context, 0.0, width);
    
    float fw = size.width;
    float fh = size.height;
    
    CGContextMoveToPoint(context, fw, fh * 0.5);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw * 0.5, fh, cornerRadius);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh * 0.5, cornerRadius); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw * 0.5, 0, cornerRadius); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh * 0.5, cornerRadius); // Back to lower right
    CGContextClosePath(context);
    //CGContextDrawPath(context, kCGPathFillStroke);
    CGContextClip(context);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    // 圆角 边框
    float inset = 0.0;
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextSetLineWidth(context, lineWidth);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(inset * 0.5,
                                                                            inset * 0.5,
                                                                            size.width - inset,
                                                                            size.height - inset)
                                               byRoundingCorners:(UIRectCornerAllCorners)
                                                     cornerRadii:CGSizeMake(cornerRadius - inset, cornerRadius - inset)];
    path.lineWidth = lineWidth;
    [path stroke];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 绘图
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
