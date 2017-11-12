//
//  ZGPanProcessView.m
//  ZGPhotoBrowser
//
//  Created by 徐宗根 on 2017/11/10.
//  Copyright © 2017年 zongGen. All rights reserved.
//

#import "ZGPanProcessView.h"
CGFloat alphaBasePanProcessValue = 360.0;
CGFloat scaleBasePanProcessValue = 800.0;

@implementation ZGPanProcessView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.alphaProcessValue = alphaBasePanProcessValue;
        self.scaleProcessValue = scaleBasePanProcessValue;
        
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.frame = self.bounds;
        [self addSubview:_maskView];
        
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.frame = self.bounds;
        [self addSubview:_imgView];
    }
    return self;
}

- (void)setProcessPoint:(CGPoint)p
{
    //    if (p.y > 0) { // 向下
    //    }else { // 向上
    //    }

//    NSLog(@"%f,%f",self.alphaProcessValue,self.scaleProcessValue);
    self.alphaProcessValue -= p.y;
    self.scaleProcessValue -= p.y;
    
    self.alphaProcessPrecent = self.alphaProcessValue / alphaBasePanProcessValue;
    self.scaleProcessPrecent = self.scaleProcessValue / scaleBasePanProcessValue;
//    NSLog(@"%f,%f",self.alphaProcessPrecent,self.scaleProcessPrecent);
    
    
    // 缩放
    self.imgView.transform = CGAffineTransformMakeScale(self.scaleProcessPrecent, self.scaleProcessPrecent);

    // 透明
    self.maskView.alpha = self.alphaProcessPrecent;
    
    // 跟随手指移动
    CGPoint center =  self.imgView.center;
    center.x += p.x;
    center.y += p.y;
    self.imgView.center = center;
}


- (void)reset
{
    self.alphaProcessValue = alphaBasePanProcessValue;
    self.scaleProcessValue = scaleBasePanProcessValue;
//    self.imgView.transform = CGAffineTransformIdentity;
//    self.imgView.frame = self.bounds;
    self.maskView.alpha = 1;
}

@end
