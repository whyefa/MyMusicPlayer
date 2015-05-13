//
//  CycleScrollView.m
//  PagedScrollView
//
//  Created by 陈政 on 14-1-23.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import "CycleScrollView.h"
#import "PlayerControlDiscItem.h"
@interface CycleScrollView () <UIScrollViewDelegate>

@property (nonatomic , assign) NSInteger currentPageIndex;
@property (nonatomic , assign) NSInteger totalPageCount;
@property (nonatomic , strong) NSMutableArray *contentViews;
@property (nonatomic , strong) UIScrollView *scrollView;
@property (nonatomic, strong) PlayerControlDiscItem *itemA;
@property (nonatomic, strong) PlayerControlDiscItem *itemB;
@property (nonatomic, strong) PlayerControlDiscItem *itemC;

@end

@implementation CycleScrollView
{
    BOOL flag;
}
- (void)setTotalPagesCount:(NSInteger (^)(void))totalPagesCount
{
    _totalPageCount = totalPagesCount();
    if (_totalPageCount > 0) {
        [self configContentViews];
    }
}
- (void)dealloc{
    _scrollView.delegate = nil;

}

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration
{
    self = [self initWithFrame:frame];

    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        flag = NO;
        self.autoresizesSubviews = YES;
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.autoresizingMask = 0xFF;
        _scrollView.contentMode = UIViewContentModeCenter;
        _scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
        _scrollView.delegate = self;
        _scrollView.contentOffset = CGPointMake(CGRectGetWidth(_scrollView.frame), 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = BACKGROUND_COLOR;
        _scrollView.showsHorizontalScrollIndicator = NO;
     
  

        _currentPageIndex = 0;
        CGFloat width = kScreenWidth - 110;
        _itemA = [[PlayerControlDiscItem alloc]initWithFrame:CGRectMake(0, 0, width, 54)];
        _itemB = [[PlayerControlDiscItem alloc]initWithFrame:CGRectMake(width, 0, width, 54)];
        _itemC = [[PlayerControlDiscItem alloc]initWithFrame:CGRectMake(width*2, 0, width, 54)];
        [_scrollView addSubview:_itemA];
        [_scrollView addSubview:_itemB];
        [_scrollView addSubview:_itemC];

        [self addSubview:_scrollView];

    }
    return self;
}

#pragma mark - 私有函数
//创建子视图
- (void)configContentViews
{
//    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
            [self addGestureRecognizer:tapGesture];
//    NSInteger counter = 0;
//    for (UIView *contentView in _contentViews) {
//        contentView.userInteractionEnabled = YES;
    //        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
    //        [contentView addGestureRecognizer:tapGesture];
//        CGRect rightRect = contentView.frame;
//        rightRect.origin = CGPointMake(CGRectGetWidth(_scrollView.frame) * (counter ++), 0);
//        contentView.frame = rightRect;
//        [_scrollView addSubview:contentView];
//    }

    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource
{

    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:_currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:_currentPageIndex + 1];
    if (_contentViews == nil) {
        _contentViews = [@[] mutableCopy];
    }
    [_contentViews removeAllObjects];
    
    if (_fetchContentViewAtIndex) {
        [_contentViews addObject:_fetchContentViewAtIndex(previousPageIndex)];
        [_contentViews addObject:_fetchContentViewAtIndex(_currentPageIndex)];
        [_contentViews addObject:_fetchContentViewAtIndex(rearPageIndex)];
        [self resetContent];
        
    }
}
- (void)resetContent {
    [_itemA setWithDict:[_contentViews objectAtIndex:0]];
    [_itemB setWithDict:[_contentViews objectAtIndex:1]];
    [_itemC setWithDict:[_contentViews objectAtIndex:2]];
    if (_SwipeBlock) {
        self.SwipeBlock(_currentPageIndex);
    }
}
- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{

    if(currentPageIndex == -1) {
        return _totalPageCount - 1;
    } else if (currentPageIndex == _totalPageCount) {
        return 0;
    } else {
        return currentPageIndex;
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    flag = NO;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (flag == NO) {
        int contentOffsetX = scrollView.contentOffset.x;
        if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
            _currentPageIndex = [self getValidNextPageIndexWithPageIndex:_currentPageIndex + 1];
            [self configContentViews];
            flag = YES;
        }
        if(contentOffsetX <= 0) {
            _currentPageIndex = [self getValidNextPageIndexWithPageIndex:_currentPageIndex - 1];
            [self configContentViews];
            flag = YES;
        }
        
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}


#pragma mark -
#pragma mark - 响应事件

- (void)animationTimerDidFired
{
      CGPoint newOffset = CGPointMake(_scrollView.contentOffset.x + CGRectGetWidth(_scrollView.frame), _scrollView.contentOffset.y);
    [_scrollView setContentOffset:newOffset animated:YES];
}

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{

    if (self.TapActionBlock) {
        self.TapActionBlock(self.currentPageIndex);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
