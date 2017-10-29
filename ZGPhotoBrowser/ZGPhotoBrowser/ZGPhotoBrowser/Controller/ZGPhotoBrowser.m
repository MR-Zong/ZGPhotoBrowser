//
//  ZGPhotoBrowser.m
//  ZGPhotoBrowser
//
//  Created by 徐宗根 on 2017/10/29.
//  Copyright © 2017年 zongGen. All rights reserved.
//

#import "ZGPhotoBrowser.h"
#import "ZGProgressHUD.h"

@interface ZGPhotoCell () <UIScrollViewDelegate>

@end

@implementation ZGPhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        self.scrollView = scrollView;
        scrollView.delegate = self;
        scrollView.maximumZoomScale = 2.0;
        scrollView.minimumZoomScale = 1.0;
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.contentView  addSubview:scrollView];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        self.imageView = imageView;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [scrollView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTap:)];
        [imageView addGestureRecognizer:tapGesture];
    }
    
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    self.imageView.frame = self.scrollView.bounds;
}


#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    [self.imageView setCenter:CGPointMake(xcenter, ycenter)];
}

#pragma mark - imageViewDidTap
- (void)imageViewDidTap:(UITapGestureRecognizer *)tapGesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoCellImageViewDidTap)]) {
        [self.delegate photoCellImageViewDidTap];
    }
    
}

@end

#pragma mark - ----------------------------------

@interface ZGPhotoBrowser () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ZGPhotoCellDelegate>

@property (weak, nonatomic) UICollectionView *collectionView;

@property (weak, nonatomic) UIView *bottomBarView;

@end


@implementation ZGPhotoBrowser


static NSString * const kPhotoCellID = @"kPhotoCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
}


- (void)setupViews
{
    [self initialize];
    [self setupCollectionView];
    [self setupBackBarButton];
    [self setupBottomBarView];
}

- (void)initialize
{
    ;
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
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -44, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:flowLayout];
    self.collectionView = collectionView;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    [collectionView registerClass:[ZGPhotoCell class] forCellWithReuseIdentifier:kPhotoCellID];
    [self.view addSubview:collectionView];
    [collectionView scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
}


- (void)setupBottomBarView
{
    UIView *bottomBarView = [[UIView alloc] init];
    self.bottomBarView = bottomBarView;
    bottomBarView.backgroundColor = [ZG_Default_Navi_Bar_Background colorWithAlphaComponent:0.8];
    // 这里的 44*2 是跟上面collectionView的frame.y = -44有关的，不要随便模仿
    bottomBarView.frame = CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44);
    [self.view addSubview:bottomBarView];
    
//    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
////    self.sendButton = sendButton;
//    CGFloat sendButtonWidth = 60;
//    CGFloat sendButtonHeight = 22;
//    sendButton.frame = CGRectMake(self.bottomBarView.bounds.size.width - sendButtonWidth - 10, (self.bottomBarView.bounds.size.height - sendButtonHeight) / 2.0, sendButtonWidth, sendButtonHeight);
//    [sendButton setTitle:self.sendButtonTitle forState:UIControlStateNormal];
//    [sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self refreshBottomBarView];
//    [bottomBarView addSubview:sendButton];
    
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
    
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger item = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];

}

#pragma mark - ZGPhotoCycleCellDelegate
- (void)photoCycleCellImageViewDidTap
{
    self.navigationController.navigationBar.hidden = !self.navigationController.navigationBar.hidden;
    self.bottomBarView.hidden = !self.bottomBarView.hidden;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - refreshBottomBarView
- (void)refreshBottomBarView
{
    
//    CGFloat sendButtonWidth = [[self.sendButton titleForState:UIControlStateNormal] sizeWithAttributes:@{NSFontAttributeName :self.sendButton.titleLabel.font}].width + 20;
//    self.sendButton.frame = CGRectMake(self.view.bounds.size.width - sendButtonWidth, (self.bottomBarView.bounds.size.height - 22) / 2.0, sendButtonWidth, self.sendButton.bounds.size.height);
    
}

- (void)showAlertMessage:(NSString *)message view:(UIView *)view
{
//    [ZGProgressHUD showInView:view message:message mode:ZGProgressHUDModeToast];
}

@end
