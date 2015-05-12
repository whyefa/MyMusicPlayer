//
//  AppDelegate.m
//  MyMusicPlayer
//
//  Created by 游侠 on 15-3-28.
//  Copyright (c) 2015年 rc. All rights reserved.
//

#import "AppDelegate.h"

#import "RCSegmentController.h"
#import "MyViewController.h"
#import "MusicStoreViewController.h"
#import "FindViewController.h"






@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.window makeKeyAndVisible];
    
    //加载根视图控制器
    [self setRootViewController];
    
    [self.window makeKeyAndVisible];

    return YES;
}

#pragma  mark- 加载RootViewController
- (void)setRootViewController{
    
    MyViewController *mvc = [[MyViewController alloc]init];
    mvc.title = @"我的";
    MusicStoreViewController *msvc = [[MusicStoreViewController alloc]init];
    msvc.title = @"音乐馆";
    FindViewController *fvc = [[FindViewController alloc]init];
    fvc.title = @"发现";
    NSMutableArray *vcs = [NSMutableArray arrayWithObjects:mvc, msvc, fvc, nil];

    self.segmentController = [[RCSegmentController alloc] initWithViewControllers:vcs];
    //    self.slideSegmentController.indicatorInsets = UIEdgeInsetsMake(0, 8, 0, 8);
    self.segmentController.indicator.backgroundColor = [UIColor redColor];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:self.segmentController];
    self.window.rootViewController = navi;
    self.segmentController.delegate = self;
    self.segmentController.dataSource = self;
    self.segmentController = [[RCSegmentController alloc] initWithViewControllers:vcs];
    //    self.slideSegmentController.indicatorInsets = UIEdgeInsetsMake(0, 8, 0, 8);
    self.segmentController.indicator.backgroundColor = [UIColor redColor];
    self.navigationController = [[UINavigationController alloc]initWithRootViewController:_segmentController];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    UITabBarController *bar = [[UITabBarController alloc]init];
    bar.viewControllers = @[_navigationController];
    
    CGRect barRect = bar.tabBar.frame;
    barRect.size.height = 54;
    barRect.origin.y -= 5;
    bar.tabBar.frame = barRect;
//    [bar.tabBar sizeThatFits:CGSizeMake(kScreenWidth, 54)];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    NSArray *fileName = @[@"listen.mp3",@"turanxindong.mp3",@"nizainali.mp3",@"peiwoquliulang.mp3",@"fangxia.mp3"];

    for (int i = 0; i < fileName.count ; i ++) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[fileName objectAtIndex:i] ofType:nil];
        NSDictionary *tempDict = @{@"path":path,@"file":[fileName objectAtIndex:i]};
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:tempDict];
        [array addObject:dict];
    }

    _songControl = [[PlayerControlView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 54)];
    [_songControl setSongList:array];
    [bar.tabBar addSubview:_songControl];
    
    self.window.rootViewController = bar;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
