//
//  PlayerControlView.h
//  MyMusicPlayer
//
//  Created by iOS on 15/5/11.
//  Copyright (c) 2015年 rc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CycleScrollView.h"
@interface PlayerControlView : UIView


@property (nonatomic, strong) CycleScrollView *songListView;

///播放列表
@property (nonatomic, strong) NSMutableArray *songList;


@end
