//
//  ZGPhotoCell.h
//  ZGPhotoBrowser
//
//  Created by 徐宗根 on 2017/11/10.
//  Copyright © 2017年 zongGen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZGPhotoModel.h"
#import <UIImageView+WebCache.h>


@protocol ZGPhotoCellDelegate  <NSObject>

@optional
- (void)photoCellImageViewDidTap;

@end

@interface ZGPhotoCell : UICollectionViewCell

@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) ZGPhotoModel *model;
@property (weak, nonatomic) id <ZGPhotoCellDelegate> delegate;

@end
