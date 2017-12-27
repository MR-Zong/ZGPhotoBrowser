//
//  ZGPhotoBrowser.h
//  ZGPhotoBrowser
//
//  Created by 徐宗根 on 2017/10/29.
//  Copyright © 2017年 zongGen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZGPhotoCell.h"
#import "ZGColorDefine.h"

@class ZGPhotoModel;

@interface ZGPhotoBrowser : UIViewController

@property (strong, nonatomic) NSArray<ZGPhotoModel *> *photoArray;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)showInView:(UIView *)view controller:(UIViewController *)vc fromView:(UIView *)fromView modelAtIndex:(NSInteger)index;
- (void)disappear;



@end
