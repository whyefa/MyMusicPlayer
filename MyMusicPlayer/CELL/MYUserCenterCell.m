//
//  MYUserCenterCell.m
//  MyMusicPlayer
//
//  Created by 游侠 on 15/5/10.
//  Copyright (c) 2015年 rc. All rights reserved.
//

#import "MYUserCenterCell.h"

@implementation MYUserCenterCell{
    BOOL created;
    /// 用户头像
    UIImageView *_icon;
    /// 用户昵称
    UILabel *_userName;
}

- (void)creatUI{
    created = YES;
    _userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _userBtn.frame = CGRectMake(5, 0, 200, 60);
    
    _icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    _icon.layer.cornerRadius = 20.0f;
    [_userBtn addSubview:_icon];
    _userName = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 200, 40)];
    _userName.textColor = TextColor;
    [_userBtn addSubview:_userName];
    
}
- (void)setWithDict:(NSDictionary*)dict{
    if (created == NO) {
        [self creatUI];
    }
    _userName.text = @"亦未";
    _icon.image = [UIImage imageNamed:@"head_icon.jpg"];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
