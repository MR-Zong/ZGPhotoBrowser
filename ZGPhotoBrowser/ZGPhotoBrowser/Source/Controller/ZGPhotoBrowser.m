//
//  ZGPhotoBrowser.m
//  ZGPhotoBrowser
//
//  Created by 徐宗根 on 2017/10/29.
//  Copyright © 2017年 zongGen. All rights reserved.
//

#import "ZGPhotoBrowser.h"
#import "ZGProgressHUD.h"
#import "ZGBrowserBottomView.h"
#import "ZGPanProcessView.h"


@interface ZGPhotoBrowser () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ZGPhotoCellDelegate,ZGBrowserBottomViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) ZGPanProcessView *panProcessView;
@property (nonatomic, assign) BOOL shouldPan;
@property (nonatomic, assign) CGRect fromRect;
@property (strong, nonatomic) ZGBrowserBottomView *bottomView;
@property (assign, nonatomic) CGPoint oldContentOffset;

@end

static NSString * const kPhotoCellID = @"kPhotoCellID";

@implementation ZGPhotoBrowser

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
}

- (void)setupViews
{
    [self initialize];
    [self setupCollectionView];
    [self setupBackBarButton];
    [self setupBottomView];
}

- (void)initialize
{
    UIPanGestureRecognizer *pan  = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];

}

- (void)setupBackBarButton
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.bounds.size.width , self.view.bounds.size.height);
    layout.minimumInteritemSpacing = 0.0;
    layout.minimumLineSpacing = 30.0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 30);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width + 30, self.view.bounds.size.height) collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    collectionView.alwaysBounceHorizontal = YES;
    [collectionView registerClass:[ZGPhotoCell class] forCellWithReuseIdentifier:kPhotoCellID];
    [self.view addSubview:collectionView];
    
    // panProcessView
    _panProcessView = [[ZGPanProcessView alloc] initWithFrame:self.view.bounds];
    _panProcessView.hidden = YES;
    [self.view addSubview:_panProcessView];
    
}

- (void)setupBottomView
{
    _bottomView = [[ZGBrowserBottomView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
    _bottomView.delegate = self;
    [self.view addSubview:_bottomView];
        
}

#pragma mark - showInView
- (void)showWithController:(UIViewController *)vc originView:(UIView *)originView modelAtIndex:(NSInteger)index
{
    if (self.photoArray.count == 0) {
        return;
    }
    if (index > self.photoArray.count - 1) {
        return;
    }
    
    self.fromRect  = [originView convertRect:originView.bounds toView:vc.view];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    [vc.view addSubview:self.view];
    [vc addChildViewController:self];
    
    CGRect fromFrame = self.fromRect;
    CGRect toFrame = self.panProcessView.bounds;
    ZGPhotoModel *model = self.photoArray[index];
    self.panProcessView.imgView.image = model.img;
    self.panProcessView.imgView.frame = fromFrame;
    self.panProcessView.hidden = NO;
    
    
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:3 options:UIViewAnimationOptionCurveLinear animations:^{
        self.panProcessView.imgView.frame = toFrame;
    } completion:^(BOOL finished) {
        self.panProcessView.hidden = YES;
    }];
    
}

- (void)dismiss
{
    if (self.view.superview) {
        
        // panView.imageView 要动画过度
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
            self.panProcessView.imgView.transform = CGAffineTransformIdentity;
            self.panProcessView.imgView.frame = self.fromRect;
        } completion:^(BOOL finished) {
            [self reset];
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }];

    }
}

- (void)disappear
{
    if (self.view.superview) {
        [self reset];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
}


#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZGPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellID forIndexPath:indexPath];
    
    cell.scrollView.zoomScale = 1.0;
    cell.delegate = self;
    cell.model = self.photoArray[indexPath.item];
    
    return cell;
}

#pragma mark - ZGPhotoCycleCellDelegate
- (void)photoCycleCellImageViewDidTap
{
    self.navigationController.navigationBar.hidden = !self.navigationController.navigationBar.hidden;
    self.bottomView.hidden = !self.bottomView.hidden;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - ZGBrowserBottomViewDelegate
- (void)browserBottomViewDidSaveBtn:(ZGBrowserBottomView *)bottomView
{
    NSIndexPath *indexPath = [self.collectionView indexPathsForVisibleItems].firstObject;
    ZGPhotoCell *cell = (ZGPhotoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    UIImage *img = cell.imageView.image;
    [self saveImageToAlbum:img];
}

- (void)saveImageToAlbum:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    }else {
        [ZGProgressHUD showInView:self.view message:@"保存成功" mode:ZGProgressHUDModeToast];
    }
}


#pragma mark - refreshBottomBarView
- (void)showAlertMessage:(NSString *)message view:(UIView *)view
{
    [ZGProgressHUD showInView:view message:message mode:ZGProgressHUDModeToast];
}

#pragma mark - setter
- (void)setPhotoArray:(NSArray<ZGPhotoModel *> *)photoArray
{
    _photoArray = photoArray;
    
    [self.collectionView reloadData];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        if([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPinchGestureRecognizer")]){
            return NO;
        }
        
    }

    return YES;
}

- (void)didPan:(UIPanGestureRecognizer *)pan
{
    CGPoint p = [pan translationInView:self.view];
    CGPoint v = [pan velocityInView:self.view];
    
    ZGPhotoCell *cell = (ZGPhotoCell *)[self.collectionView cellForItemAtIndexPath:[self.collectionView indexPathsForVisibleItems].firstObject];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        // 如果 图片有被放大，要回到原来图片大小
        cell.scrollView.zoomScale = 1;
        
        if (p.x != 0) {
            self.shouldPan = NO;
        }else {
            
            if (fabs(v.x) < 100) {
                self.shouldPan = YES;
            }else {
                self.shouldPan = NO;
            }
        }
        
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        if (self.shouldPan == YES) {
            [pan setTranslation:CGPointZero inView:self.view];
            self.collectionView.hidden = YES;
            self.bottomView.hidden = YES;
            self.panProcessView.hidden = NO;

            self.panProcessView.imgView.image = cell.imageView.image;

            [self.panProcessView setProcessPoint:p];
            
        }
        
    }else if (pan.state == UIGestureRecognizerStateEnded) {
        if (self.shouldPan == YES) {
            
            if (self.panProcessView.alphaProcessPrecent < 0.2) {
                [self dismiss];
            }else {
                [UIView animateWithDuration:0.25 animations:^{
                    self.panProcessView.maskView.alpha = 1;
                    self.panProcessView.imgView.transform = CGAffineTransformIdentity;
                    self.panProcessView.imgView.frame = self.panProcessView.bounds;
                } completion:^(BOOL finished) {
                    [self reset];
                }];
            }
        }
    }else {
        self.panProcessView.hidden = YES;
    }
}

- (void)reset
{
    [self.panProcessView reset];
    self.collectionView.hidden = NO;
    self.bottomView.hidden = NO;
    self.panProcessView.hidden = YES;
}

@end
