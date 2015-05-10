//
//  RCSegmentController.h
//  RCSegmentController
//
//  Created by 游侠 on 15-3-30.
//  Copyright (c) 2015年 rc. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const segmentBarItemID;
@class RCSegmentController;

@protocol RCSegmentControllerDataSource <NSObject>

@required
- (NSInteger)segment:(UICollectionView*)segmentBar numberOfItemsInSection:(NSInteger)section;

- (UICollectionViewCell*)segment:(UICollectionView*)segmentBar cellForItmeAtIndexPath:(NSIndexPath*)indexPath;

@optional

- (NSInteger)numberOfSectionsInSement:(UICollectionView*)segmentBar;

@end

@protocol RCSegmentControllerDelegate <NSObject>

@optional
- (void)segment:(UICollectionView*)segmentBar didSelectedViewController:(UIViewController*)viewController;

- (void)segment:(UICollectionView*)segmentBar shouldSelectViewController:(UIViewController*)viewController;

@end
@interface RCSegmentController : UIViewController

@property (nonatomic,copy) NSArray *viewControllers;

@property (nonatomic,strong,readonly) UIScrollView *slideView;

@property (nonatomic,strong,readonly) UIView *indicator;

@property (nonatomic,assign) UIEdgeInsets indicatorInsets;

@property (nonatomic,weak,readonly) UIViewController *selectedViewController;

@property (nonatomic,assign,readonly)NSInteger selectedIndex;

@property (nonatomic,assign) NSInteger titleIndex;

@property (nonatomic,assign) id<RCSegmentControllerDataSource>dataSource;

@property (nonatomic,assign) id<RCSegmentControllerDelegate>delegate;
- (instancetype)initWithViewControllers:(NSArray*)viewControllers;

- (void)scrollToViewWithIndex:(NSInteger)index animated:(BOOL)animated;

@end
