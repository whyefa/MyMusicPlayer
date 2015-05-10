//
//  AppDelegate.h
//  MyMusicPlayer
//
//  Created by 游侠 on 15-3-28.
//  Copyright (c) 2015年 rc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCSegmentController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,RCSegmentControllerDataSource,RCSegmentControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) RCSegmentController *segmentController;
@property (strong, nonatomic) UINavigationController *navigationController;

@end

