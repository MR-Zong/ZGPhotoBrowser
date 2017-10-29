//
//  ZGProgressHUD.h
//  ZGProgressHUD
//
//  Created by 徐宗根 on 16/12/3.
//  Copyright © 2016年 XuZonggen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ZGProgressHUDMode){
    ZGProgressHUDModeIndeterminate, // 一直显示，不消失
    ZGProgressHUDModeText, // 显示文本，1秒后消失
    ZGProgressHUDModeToast, // 跟text一样效果
};

@interface ZGProgressHUD : UIView

+ (void)showInView:(UIView *)view message:(NSString *)message mode:(ZGProgressHUDMode)mode;
+ (void)dismiss;

/** 多个progressHud 要同时存在在同一个view时候
 * 就需要 alloc init 多个ZGProgressHUD
 * 让他们互相独立，互不干扰
 */
- (void)showInView:(UIView *)view message:(NSString *)message mode:(ZGProgressHUDMode)mode;
- (void)dismiss;


@end
