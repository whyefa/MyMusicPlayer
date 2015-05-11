//
//  PlayerControlView.m
//  MyMusicPlayer
//
//  Created by iOS on 15/5/11.
//  Copyright (c) 2015年 rc. All rights reserved.
//

#import "PlayerControlView.h"
#import "PlayerControlDiscItem.h"
@implementation PlayerControlView
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _songList = [[NSMutableArray alloc]init];
        [self configSubView];
        
    }
    return self;
}

- (void)configSubView {
    _songListView = [[CycleScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 110, 54) animationDuration:0];
    [self addSubview:_songListView];
}

- (void)setSongList:(NSMutableArray *)songList {
    if (_songList == songList) {
        return;
    }
    _songList = songList;
    
//    NSMutableArray * viewsArray = [@[]mutableCopy];
//    for (int i = 0; i < _songList.count; i ++) {
//        PlayerControlDiscItem *discItem = [[PlayerControlDiscItem alloc]init];
//        [discItem setWithDict:[_songList objectAtIndex:i]];
//        [viewsArray addObject:discItem];
//    }
    
    __block NSMutableArray *sl = _songList;
    _songListView.fetchContentViewAtIndex = ^NSDictionary *(NSInteger pageIndex){
        return sl[pageIndex];
    };
    __block NSMutableArray *array = _songList;
    _songListView.totalPagesCount = ^NSInteger(void){
        return array.count;
    };
}
@end
