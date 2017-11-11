//
//  ZGPanProcessView.h
//  ZGPhotoBrowser
//
//  Created by 徐宗根 on 2017/11/10.
//  Copyright © 2017年 zongGen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZGPanProcessView : UIView

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, assign) CGFloat alphaProcessValue;
@property (nonatomic, assign) CGFloat scaleProcessValue;

// 值在0~1 百分比
@property (nonatomic, assign) CGFloat alphaProcessPrecent;
@property (nonatomic, assign) CGFloat scaleProcessPrecent;

- (void)reset;
- (void)setProcessPoint:(CGPoint)p;

@end
