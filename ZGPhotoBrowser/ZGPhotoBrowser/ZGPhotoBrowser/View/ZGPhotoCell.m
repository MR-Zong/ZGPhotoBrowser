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
        
        ZGScrollViewPan *scrollView = [[ZGScrollViewPan alloc] init];
        self.scrollView = scrollView;
        scrollView.delegate = self;
        scrollView.maximumZoomScale = 2.0;
        scrollView.minimumZoomScale = 1.0;
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        scrollView.alwaysBounceVertical = YES;
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
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
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

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    CGSize contSize = scrollView.contentSize;
//    contSize.width += 100;
//    contSize.height += 100;
//    scrollView.contentSize = contSize;
//
//
//    self.imageView.frame = CGRectMake((contSize.width - scrollView.bounds.size.width ) / 2.0, (contSize.height - scrollView.bounds.size.height ) / 2.0, scrollView.bounds.size.width, scrollView.bounds.size.height);
//
//    [scrollView scrollRectToVisible:self.imageView.frame animated:NO];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    CGSize contSize = scrollView.contentSize;
//    contSize.width = scrollView.bounds.size.width;
//    contSize.height = scrollView.bounds.size.height;
//    scrollView.contentSize = contSize;
//
//    self.imageView.frame = CGRectMake(0,0, scrollView.bounds.size.width, scrollView.bounds.size.height);
//
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
    
    
    
//    for (UIGestureRecognizer *ges in scrollView.gestureRecognizers) {
//        if ([ges isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")]) {
//            UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)ges;
//            CGPoint p =[pan translationInView:self];
//            NSLog(@"(%zd,%zd)",p.x,p.y);
//        }
//    }
}



#pragma mark - imageViewDidTap
- (void)imageViewDidTap:(UITapGestureRecognizer *)tapGesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoCellImageViewDidTap)]) {
        [self.delegate photoCellImageViewDidTap];
    }
    
}

@end

