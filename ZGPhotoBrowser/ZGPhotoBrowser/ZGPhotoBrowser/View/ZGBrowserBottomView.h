//
//  ZGBrowserBottomView.h
//  ZGPhotoBrowser
//
//  Created by 徐宗根 on 2017/10/29.
//  Copyright © 2017年 zongGen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZGBrowserBottomView;

@protocol ZGBrowserBottomViewDelegate <NSObject>

- (void)browserBottomViewDidSaveBtn:(ZGBrowserBottomView *)bottomView;

@end

@interface ZGBrowserBottomView : UIView

@property (nonatomic,weak) id <ZGBrowserBottomViewDelegate> delegate;

@end
