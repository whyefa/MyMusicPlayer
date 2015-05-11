//
//  RCSegmentController.m
//  RCSegmentController
//
//  Created by 游侠 on 15-3-30.
//  Copyright (c) 2015年 rc. All rights reserved.
//

#import "RCSegmentController.h"
#import "MoreViewController.h"
#import "SearchViewController.h"


#define  SEGMENT_BAR_HEIGHT 44
#define INDICATOR_HEIGHT 2

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

NSString *const segmentBarItemID = @"RCSegmentBarItem";

@interface RCSegmentBarItem:UICollectionViewCell

@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation RCSegmentBarItem

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}
- (UILabel*)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:self.contentView.bounds];
        _titleLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithWhite:0.92 alpha:0.6];
    }
    return _titleLabel;
}
@end



@interface RCSegmentController()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong,readwrite) UICollectionView *segmentBar;
@property (nonatomic,strong,readwrite) UIScrollView *slideView;
@property (nonatomic,assign,readwrite) NSInteger selectedIndex;
@property (nonatomic,strong)UIView *indicator;
@property (nonatomic,strong) UICollectionViewFlowLayout *segmentBarLayout;

- (void)reset;
@end
@implementation RCSegmentController

@synthesize viewControllers = _viewControllers;
- (instancetype)initWithViewControllers:(NSArray *)viewControllers{
    self = [super init];
    if (self) {
        _viewControllers  = [viewControllers copy];
        _selectedIndex = NSNotFound;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupSubviews];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGSize contentSize = CGSizeMake(self.view.frame.size.width*self.viewControllers.count, 0);
    [self.slideView setContentSize:contentSize];
    [self reset];
}
#pragma  mark - Setup

- (void)setupSubviews{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.view addSubview:self.slideView];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:205/255.0 blue:105/255.0 alpha:1];
    [self.navigationItem setTitleView:self.segmentBar];
    [self.segmentBar registerClass:[RCSegmentBarItem class] forCellWithReuseIdentifier:segmentBarItemID];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, 44, 44);
    [btn1 setImage:[UIImage imageNamed:@"local_search_icon_normal"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"maintabbar_button_setting_highlight"] forState:UIControlStateHighlighted];
    btn1.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    [btn1 addTarget:self action:@selector(showSeachController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn1];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, 0, 60, 44);
    [btn2 setImage:[UIImage imageNamed:@"maintabbar_button_setting_normal"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"maintabbar_button_setting_highlight"] forState:UIControlStateHighlighted];
    btn2.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [btn2 addTarget:self action:@selector(showMoreController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:btn2];
    self.navigationItem.leftBarButtonItem = leftItem;

}

#pragma mark- NavigationItem action
- (void)showSeachController {
    SearchViewController *svc = [[SearchViewController alloc]init];
    [self.navigationController presentViewController:svc animated:NO completion:^{
        
    }];
}

- (void)showMoreController {
    MoreViewController *mvc = [[MoreViewController alloc]init];
    mvc.title = @"更多";
    [self.navigationController pushViewController:mvc animated:YES];
}

#pragma mark - Property
- (UIScrollView*)slideView{
    if (!_slideView) {
        CGRect frame = self.view.bounds;
//        frame.size.height -= _segmentBar.frame.size.height;
        frame.origin.y = 0;
        _slideView = [[UIScrollView alloc]initWithFrame:frame];
        _slideView.backgroundColor = BACKGROUND_COLOR;
        [_slideView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
        [_slideView setShowsHorizontalScrollIndicator:NO];
        [_slideView setShowsVerticalScrollIndicator:NO];
        [_slideView setPagingEnabled:YES];
        [_slideView setBounces:YES];
        [_slideView setDelegate:self];
    }
    return _slideView;
}

- (UICollectionView*)segmentBar{
    if (!_segmentBar) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGRect frame = CGRectMake(0, 0,width-150 , 44);
        _segmentBar = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:self.segmentBarLayout];
        _segmentBar.backgroundColor = [UIColor clearColor];
        _segmentBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _segmentBar.delegate = self;
        _segmentBar.dataSource = self;
    }
    return _segmentBar;
}

- (UIView*)indicatorBgView{
    return nil;
}
- (UIView*)indicator{
    return nil;
}


- (UICollectionViewFlowLayout*)segmentBarLayout{
    if (!_segmentBarLayout) {
        _segmentBarLayout = [[UICollectionViewFlowLayout alloc]init];
        _segmentBarLayout.itemSize = CGSizeMake((self.view.frame.size.width-150)/self.viewControllers.count, SEGMENT_BAR_HEIGHT);
        _segmentBarLayout.sectionInset = UIEdgeInsetsZero;
        _segmentBarLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _segmentBarLayout.minimumInteritemSpacing = 0;
        _segmentBarLayout.minimumLineSpacing = 0;
    }
    return _segmentBarLayout;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    if (_selectedIndex == selectedIndex) {
        return;
    }
    NSParameterAssert(selectedIndex>= 0 && selectedIndex <self.viewControllers.count);
    UIViewController *toSelectController = [self.viewControllers objectAtIndex:selectedIndex];
    if (!toSelectController.parentViewController) {
        [self addChildViewController:toSelectController];
        CGRect rect = self.slideView.bounds;
        rect.origin.x = rect.size.width*selectedIndex;
        toSelectController.view.frame = rect;
        [self.slideView addSubview:toSelectController.view];
        [toSelectController didMoveToParentViewController:self];
    }
    _selectedIndex = selectedIndex;
    
}
- (void)setViewControllers:(NSArray *)viewControllers{
    for (UIViewController *vc  in _viewControllers) {
        [vc removeFromParentViewController];
    }
    _viewControllers = [viewControllers copy];
    [self reset];
}

- (NSArray*)viewControllers{
    return [_viewControllers copy];
}

- (UIViewController*)selectedViewController{
    return self.viewControllers[self.selectedIndex];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if ([_dataSource respondsToSelector:@selector(numberOfSectionsInSement:)]) {
        return [_dataSource numberOfSectionsInSement:collectionView];
    }
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([_dataSource respondsToSelector:@selector(segment:numberOfItemsInSection:)]) {
        return [_dataSource segment:collectionView numberOfItemsInSection:section];
    }
    return self.viewControllers.count;
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([_dataSource respondsToSelector:@selector(segment:cellForItmeAtIndexPath:)]) {
        return [_dataSource segment:collectionView cellForItmeAtIndexPath:indexPath];
    }

    
    RCSegmentBarItem *segmentBarItem = [collectionView dequeueReusableCellWithReuseIdentifier:segmentBarItemID forIndexPath:indexPath];
    
    UIViewController *vc = self.viewControllers[indexPath.row];
    segmentBarItem.titleLabel.text = vc.title;
    if (_titleIndex == indexPath.row) {
        segmentBarItem.titleLabel.textColor = [UIColor whiteColor];
    }else{
        segmentBarItem.titleLabel.textColor = [UIColor colorWithWhite:0.93 alpha:0.6];
    }

    return segmentBarItem;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 0 || indexPath.row >= self.viewControllers.count) {
        return;
    }
    UIViewController *vc  = self.viewControllers[indexPath.row];
    if ([_delegate respondsToSelector:@selector(segment:didSelectedViewController:)]) {
        [_delegate segment:collectionView didSelectedViewController:vc];
    }
    [self setSelectedIndex:indexPath.row];
    [self scrollToViewWithIndex:self.selectedIndex animated:NO];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 0 || indexPath.row >= self.viewControllers.count) {
        return NO;
    }
    BOOL flag = YES;
    UIViewController *vc = self.viewControllers[indexPath.row];
    if ([_delegate respondsToSelector:@selector(segment:shouldSelectViewController:)]) {
        [_delegate segment:collectionView didSelectedViewController:vc];
    }
    return flag;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.slideView) {
        CGFloat percent = scrollView.contentOffset.x/scrollView.contentSize.width;
        if(percent <= 1/6.0f){
            _titleIndex = 0;
            [_segmentBar reloadData];
        }else if(percent > 1/6.0f && percent <= 0.5f){
            _titleIndex = 1;
            [_segmentBar reloadData];
        }else if(percent > .5f){
            _titleIndex = 2;
            [_segmentBar reloadData];
        }
        NSInteger index = ceil(percent*self.viewControllers.count);
        if (index >= 0 && index < self.viewControllers.count) {
            [self setSelectedIndex:index];
        }
    }
}

#pragma mark - Action

- (void)scrollToViewWithIndex:(NSInteger)index animated:(BOOL)animated{
    CGRect rect = self.slideView.bounds;
    rect.origin.x = rect.size.width*index;
    [self.slideView setContentOffset:CGPointMake(rect.origin.x, rect.origin.y) animated:animated];
}

- (void)reset{
    _selectedIndex = NSNotFound;
    [self scrollToViewWithIndex:0 animated:NO];
    [self setSelectedIndex:0];
    [self.segmentBar reloadData];
}

@end
