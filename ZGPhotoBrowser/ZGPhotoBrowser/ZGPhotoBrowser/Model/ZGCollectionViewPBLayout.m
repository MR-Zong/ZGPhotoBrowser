//
//  ZGCollectionViewPBLayout.m
//  ZGPhotoBrowser
//
//  Created by 徐宗根 on 2017/10/31.
//  Copyright © 2017年 zongGen. All rights reserved.
//

#import "ZGCollectionViewPBLayout.h"

@interface ZGCollectionViewPBLayout ()

@property (nonatomic, strong) NSMutableArray *itemsAttrArray;
@property (nonatomic, assign) NSInteger pagesCount;


@end


@implementation ZGCollectionViewPBLayout
- (void)prepareLayout
{
    self.itemsAttrArray = [NSMutableArray array];
    NSLog(@"itemSize %f,%f",self.itemSize.width,self.itemSize.height);

}

- (CGSize)collectionViewContentSize
{
    self.pagesCount = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    return CGSizeMake(self.itemSize.width * self.pagesCount, self.itemSize.height);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //    NSLog(@"bounds %@",NSStringFromCGRect(self.collectionView.bounds));
//    NSLog(@"rect %@",NSStringFromCGRect(rect));
    //    NSLog(@"contentOffset %@",NSStringFromCGPoint(self.collectionView.contentOffset));
    
//    NSInteger item = (rect.origin.x) / self.collectionView.bounds.size.height;
//    NSLog(@"item = %zd",item);
//    if (item < 0) {
//        item = 0;
//    }else if (item == self.pagesCount){
//        item = self.pagesCount - 1;
//    }
    
    
    return self.itemsAttrArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.itemsAttrArray[indexPath.item];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}


#pragma mark - setter
- (void)setPagesCount:(NSInteger)pagesCount
{
    if (_pagesCount==0) {
        _pagesCount = pagesCount;
        
        NSInteger item = 0;
        for (int i=0; i<_pagesCount; i++) {
            item = i;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
            UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attr.frame = CGRectMake(item *self.itemSize.width, 0, self.itemSize.width, self.itemSize.height);
            attr.hidden = NO;
            attr.indexPath = indexPath;
            [self.itemsAttrArray addObject:attr];
        }
    }
}

@end
