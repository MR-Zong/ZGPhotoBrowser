//
//  ZGPhotoBrowser.h
//  ZGPhotoBrowser
//
//  Created by 徐宗根 on 2017/10/29.
//  Copyright © 2017年 zongGen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+DHUtil.h"

//颜色
#define ZG_Default_Cell_Background     RGBA(0x26, 0x26, 0x26, 1) //cell背景色
#define ZG_Default_Navi_Bar_Background RGBA(0x30, 0x30, 0x30, 1) //导航条背景色
#define ZG_Default_Tab_Bar_Background  RGBA(0x30, 0x30, 0x30, 1) //tabbar背景色
#define ZG_Default_VC_Backgroud_Color  RGBA(0x11, 0x11, 0x11, 1) //vc 背景色
#define ZG_Default_Tab_Bar_Tint_Color  RGBA(0x58, 0x9b, 0xda, 1) //tabbar tint color
#define ZG_Default_Tint_Colot          RGBA(0x58, 0x9b, 0xda, 1) //全局 tint color



@protocol ZGPhotoCellDelegate  <NSObject>

@optional
- (void)photoCellImageViewDidTap;

@end


@interface ZGPhotoCell : UICollectionViewCell

@property (weak, nonatomic) UIImageView *imageView;

@property (weak, nonatomic) UIScrollView *scrollView;

@property (weak, nonatomic) id <ZGPhotoCellDelegate> delegate;

@end


#pragma mark -
@class ZGPhotoModel;

@interface ZGPhotoBrowser : UIViewController

@property (strong, nonatomic) NSMutableArray<ZGPhotoModel *> *photoArray;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
