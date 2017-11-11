//
//  ZGCollectionViewPBLayout.h
//  ZGPhotoBrowser
//
//  Created by 徐宗根 on 2017/10/31.
//  Copyright © 2017年 zongGen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZGCollectionViewPBLayout : UICollectionViewLayout

@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) UIEdgeInsets sectionInset;

@end
