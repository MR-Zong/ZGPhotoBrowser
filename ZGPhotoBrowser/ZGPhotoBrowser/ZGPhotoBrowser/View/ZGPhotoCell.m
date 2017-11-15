//
//  ZGPhotoCell.m
//  ZGPhotoBrowser
//
//  Created by 徐宗根 on 2017/11/10.
//  Copyright © 2017年 zongGen. All rights reserved.
//

#import "ZGPhotoCell.h"

@interface ZGPhotoCell () <UIScrollViewDelegate,UIGestureRecognizerDelegate>


@end

@implementation ZGPhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        self.scrollView = scrollView;
        scrollView.delegate = self;
        scrollView.maximumZoomScale = 2.0;
        scrollView.minimumZoomScale = 1.0;
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.contentView  addSubview:scrollView];
        
        
        UIImageView *imageView = [[UIImageView alloc] init];
        self.imageView = imageView;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [scrollView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTap:)];
        [imageView addGestureRecognizer:tapGesture];
    }
    
    return self;
}




- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.imageView.frame = self.scrollView.bounds;
}

-(void)setModel:(ZGPhotoModel *)model
{
    _model = model;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrlString]];
}


#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    [self.imageView setCenter:CGPointMake(xcenter, ycenter)];
}


#pragma mark - imageViewDidTap
- (void)imageViewDidTap:(UITapGestureRecognizer *)tapGesture
{
    self.scrollView.zoomScale = 1;
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoCellImageViewDidTap:)]) {
        [self.delegate photoCellImageViewDidTap:self];
    }
    
}

@end

