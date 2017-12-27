//
//  ZGBrowserBottomView.m
//  ZGPhotoBrowser
//
//  Created by 徐宗根 on 2017/10/29.
//  Copyright © 2017年 zongGen. All rights reserved.
//

#import "ZGBrowserBottomView.h"
#import "ZGColorDefine.h"

@interface ZGBrowserBottomView ()
@property (nonatomic, strong) UIButton *saveBtn;
@end

@implementation ZGBrowserBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [ZG_Default_Navi_Bar_Background colorWithAlphaComponent:0.8];
        
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat saveBtnWidth = 60;
    CGFloat saveBtnHeight = 22;
    _saveBtn.frame = CGRectMake(self.bounds.size.width - saveBtnWidth - 10, (self.bounds.size.height - saveBtnHeight) / 2.0, saveBtnWidth, saveBtnHeight);
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveBtn];

}

- (void)saveBtnClick:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(browserBottomViewDidSaveBtn:)]) {
        [self.delegate browserBottomViewDidSaveBtn:self];
    }
}

@end
