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
#import "ZGPhotoModel.h"

@class ZGPhotoModel;

@interface ZGPhotoBrowser : UIViewController

/** 数据
 * photoArray : 图片数组 （元素必须是ZGPhotoModel 类型）
 */
@property (strong, nonatomic) NSArray<ZGPhotoModel *> *photoArray;

@property (nonatomic, strong) NSIndexPath *indexPath;

/** 显示
 * vc : originView 所在的控制器
 * originView : 原来显示图片的那个 imageView
 * index : 一开始显示哪张图片（多张图片）
 */
- (void)showWithController:(UIViewController *)vc originView:(UIView *)originView modelAtIndex:(NSInteger)index;

/** 消失*/
- (void)disappear;



@end
