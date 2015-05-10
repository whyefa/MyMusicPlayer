//
//  UIButton+RCConfig.h
//  MyMusicPlayer
//
//  Created by 游侠 on 15-3-30.
//  Copyright (c) 2015年 rc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (RCConfig)

- (void)setWithImage:(NSString*)image;

- (void)setWithNormalImage:(NSString*)normalImage hightLightImage:(NSString*)hightLightImage;

- (void)setEdgeInsets:(CGFloat)d;
@end
