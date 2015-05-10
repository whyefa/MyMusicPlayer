//
//  MYUserCenterCell.h
//  MyMusicPlayer
//
//  Created by 游侠 on 15/5/10.
//  Copyright (c) 2015年 rc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYUserCenterCell : UITableViewCell

///个人中心 button
@property (strong, nonatomic) UIButton *userBtn;
///开通会员 button
@property (strong, nonatomic) UIButton *vipBtn;

/// 开通会员
@property (strong, nonatomic) UILabel *vipLabel;

- (void)setWithDict:(NSDictionary*)dict;
@end
