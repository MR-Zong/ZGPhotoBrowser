//
//  ZGCollectionViewFlowLayout.m
//  ZGPhotoBrowser
//
//  Created by 徐宗根 on 2017/11/13.
//  Copyright © 2017年 zongGen. All rights reserved.
//

#import "ZGCollectionViewFlowLayout.h"

@implementation ZGCollectionViewFlowLayout

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{

    CGPoint targetContentOffset = CGPointZero;
    
    CGFloat offSetX = proposedContentOffset.x; //偏移量
    
    CGFloat itemWidth = self.itemSize.width;   //itemSizem 的宽
    
    //itemSizem的宽度+行间距 = 页码的宽度
    
    NSInteger pageWidth = itemWidth + 10;
    
    //根据偏移量计算 第几页
    
    NSInteger pageNum = (offSetX+pageWidth/2)/pageWidth;
    
    //根据显示的第几页,从而改变偏移量
    
    targetContentOffset.x = pageNum*pageWidth;
    
    //    NSLog(@"%.1f",targetContentOffset->x);
    return targetContentOffset;
}



@end
