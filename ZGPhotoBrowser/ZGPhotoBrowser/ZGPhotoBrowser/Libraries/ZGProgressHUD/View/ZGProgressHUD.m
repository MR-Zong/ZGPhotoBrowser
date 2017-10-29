//
//  ZGProgressHUD.m
//  ZGProgressHUD
//
//  Created by 徐宗根 on 16/12/3.
//  Copyright © 2016年 XuZonggen. All rights reserved.
//

#import "ZGProgressHUD.h"

ZGProgressHUD *_zgProgressHUD_;

@interface ZGProgressHUDContentView : UIView

+ (instancetype)contentViewWithView:(UIView *)view message:(NSString *)message mode:(ZGProgressHUDMode)mode;
@end

@implementation ZGProgressHUDContentView

+ (instancetype)contentViewWithView:(UIView *)view message:(NSString *)message mode:(ZGProgressHUDMode)mode
{
    ZGProgressHUDContentView *contentView = [[ZGProgressHUDContentView alloc] init];
    CGFloat contentViewWidth = view.bounds.size.width;
    CGFloat contentViewHeight = 0;
    
    if (mode == ZGProgressHUDModeIndeterminate) {
        
        contentViewWidth = 100;
        contentViewHeight = contentViewWidth;

        
        if (message.length > 0) {
        
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((contentViewWidth - 60) / 2.0, 10, 60, 60)];
            indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            [indicator startAnimating];
            [contentView addSubview:indicator];
        
            UILabel *textLabel = [[UILabel alloc] init];
            textLabel.text = message;
            textLabel.textColor = [UIColor whiteColor];
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.font = [UIFont systemFontOfSize:18];
            textLabel.frame = CGRectMake(0,60 + 10,contentViewWidth,21);
            [contentView addSubview:textLabel];
        }else {
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((contentViewWidth - 60) / 2.0, (contentViewHeight - 60) / 2.0, 60, 60)];
            indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            [indicator startAnimating];
            [contentView addSubview:indicator];

        }
    }else if (mode == ZGProgressHUDModeText || mode == ZGProgressHUDModeToast){
        if (message.length > 0) {
            UILabel *textLabel = [[UILabel alloc] init];
            textLabel.text = message;
            textLabel.textColor = [UIColor whiteColor];
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.font = [UIFont systemFontOfSize:18];
            CGFloat textLabelHeight = 21;
            CGFloat textLabelWidth = [message boundingRectWithSize:CGSizeMake(view.bounds.size.width, textLabelHeight) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName :textLabel.font} context:nil].size.width;
            
            if (textLabelWidth >= contentViewWidth) {
                textLabelWidth = contentViewWidth - 2*20;
            }
            contentViewWidth = textLabelWidth + 2*15;
            contentViewHeight = textLabelHeight + 2*10;
            
            textLabel.frame = CGRectMake((contentViewWidth - textLabelWidth) / 2.0, (contentViewHeight - textLabelHeight) / 2.0, textLabelWidth, textLabelHeight);
            [contentView addSubview:textLabel];
        }
    }
    
    contentView.backgroundColor = [UIColor blackColor];
    contentView.layer.cornerRadius = 10;
    contentView.layer.masksToBounds = YES;
    contentView.frame = CGRectMake((view.frame.size.width - contentViewWidth) / 2.0, (view.frame.size.height - contentViewHeight) / 2.0, contentViewWidth, contentViewHeight);
    return contentView;
}

@end

@interface ZGProgressHUD ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) ZGProgressHUDContentView *contentView;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) ZGProgressHUDMode mode;

@end

@implementation ZGProgressHUD

+ (void)showInView:(UIView *)view message:(NSString *)message mode:(ZGProgressHUDMode)mode
{
    if (!view) {
        return;
    }
    
    if (_zgProgressHUD_.window) {
        [self dismiss];
    }
    _zgProgressHUD_ = [ZGProgressHUD progressHUDWithView:view message:message mode:mode];
    [view addSubview:_zgProgressHUD_];
}

- (void)showInView:(UIView *)view message:(NSString *)message mode:(ZGProgressHUDMode)mode
{
    if (!view) {
        return;
    }
    
    if (self.window) {
        [self dismiss];
    }
    
    [self removeAllSubviews];
    [self  setupViews];
    
    self.frame = view.bounds;
    self.message = message;
    self.mode = mode;
    
    [view addSubview:self];
}

+ (void)dismiss
{
    if (!_zgProgressHUD_.window) {
        return;
    }
    
    [_zgProgressHUD_ removeFromSuperview];
    _zgProgressHUD_ = nil;
}

- (void)removeAllSubviews
{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
}


+ (instancetype)progressHUDWithView:(UIView *)view message:(NSString *)message mode:(ZGProgressHUDMode)mode
{
    ZGProgressHUD *progressHUD = [[ZGProgressHUD alloc] initWithFrame:view.bounds];
    progressHUD.message = message;
    progressHUD.mode = mode;
    return progressHUD;
}

- (void)dismiss
{
    if (!self.window) {
        return;
    }
    
    [self removeFromSuperview];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    _maskView = [[UIView alloc] initWithFrame:self.bounds];
    _maskView.backgroundColor = [UIColor clearColor];
    [self addSubview:_maskView];
}

#pragma mark - setter
- (void)setMode:(ZGProgressHUDMode)mode
{
    _mode = mode;
    
    self.contentView = [ZGProgressHUDContentView contentViewWithView:self message:self.message mode:mode];
    [self addSubview:self.contentView];
    
    if (mode == ZGProgressHUDModeToast) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.alpha = 0;
            }completion:^(BOOL finished) {
                if (finished) {
                    [self dismiss];
                }
            }];
        });
    }
}

@end
