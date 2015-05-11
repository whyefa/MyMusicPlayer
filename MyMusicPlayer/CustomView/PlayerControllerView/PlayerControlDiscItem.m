//
//  PlayerControlDiscItem.m
//  MyMusicPlayer
//
//  Created by iOS on 15/5/11.
//  Copyright (c) 2015年 rc. All rights reserved.
//

#import "PlayerControlDiscItem.h"
@interface PlayerControlDiscItem()

@property (strong, nonatomic) UIImageView *icon;

@property (strong, nonatomic) UILabel *songName;

@property (strong, nonatomic) UILabel *songer;

@end
@implementation PlayerControlDiscItem
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = BACKGROUND_COLOR;
        [self configSubVeiws];
    }
    return self;
}
- (void)configSubVeiws {
    _icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 44, 44)];
    _icon.layer.cornerRadius = 22.0f;
    _icon.layer.masksToBounds = YES;
    [self addSubview:_icon];
    
    _songName = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, kScreenWidth - 55*3, 15)];
    _songName.textColor = TextColor;
    _songName.font = [UIFont systemFontOfSize:16];
    [self addSubview:_songName];
    
    _songer = [[UILabel alloc]initWithFrame:CGRectMake(60, 25 , kScreenWidth - 55*3, 15)];
    _songer.textColor = [UIColor lightGrayColor];
    _songer.font = [UIFont systemFontOfSize:15];
    [self addSubview:_songer];
}

- (void)setWithDict:(NSDictionary *)dict {
    _icon.image = [UIImage imageNamed:[dict objectForKey:@"icon"]];
    _songer.text = [dict objectForKey:@"songer"];
    _songName.text = [dict objectForKey:@"song"];
}
@end
