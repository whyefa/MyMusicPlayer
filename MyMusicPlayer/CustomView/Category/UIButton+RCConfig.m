//
//  UIButton+RCConfig.m
//  MyMusicPlayer
//
//  Created by 游侠 on 15-3-30.
//  Copyright (c) 2015年 rc. All rights reserved.
//

#import "UIButton+RCConfig.h"

@implementation UIButton (RCConfig)


- (void)setWithImage:(NSString *)image {
    [self setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
}
- (void)setWithNormalImage:(NSString*)normalImage hightLightImage:(NSString*)hightLightImage{
    [self setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:hightLightImage] forState:UIControlStateHighlighted];
}
- (void)setEdgeInsets:(CGFloat)d{
    self.imageEdgeInsets = UIEdgeInsetsMake(0, d, 0, -d);
}
@end
