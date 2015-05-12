//
//  PlayerControlDiscItem.m
//  MyMusicPlayer
//
//  Created by iOS on 15/5/11.
//  Copyright (c) 2015年 rc. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
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
//    _icon.image = [UIImage imageNamed:[dict objectForKey:@"icon"]];
    NSString *mp3File = [dict objectForKey:@"path"];
    [self getSongDetail:mp3File];
//    _icon.image = [dict objectForKey:@"icon"];
//    _songer.text = [dict objectForKey:@"songer"];
//    _songName.text = [dict objectForKey:@"song"];
}

- (void)getSongDetail:(NSString*)mp3File {
    NSMutableDictionary *retDic = [[NSMutableDictionary alloc] init];
    
    
    NSURL *url = [NSURL fileURLWithPath:mp3File];
    AVURLAsset *mp3Asset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    
    for (NSString *format in [mp3Asset availableMetadataFormats]) {
        for (AVMetadataItem *metadataItem in [mp3Asset metadataForFormat:format]) {
            
            if(metadataItem.commonKey)
                [retDic setObject:metadataItem.value forKey:metadataItem.commonKey];
            
        }
    }
    UIImage *cover = [UIImage imageWithData:[[retDic objectForKey:@"artwork"] objectForKey:@"data"]];
    _icon.image = cover;
    _songer.text = [retDic objectForKey:@"artist"];
    _songName.text = [retDic objectForKey:@"title"];
}
@end
