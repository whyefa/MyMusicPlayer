//
//  PlayerControlView.m
//  MyMusicPlayer
//
//  Created by iOS on 15/5/11.
//  Copyright (c) 2015年 rc. All rights reserved.
//

#import "PlayerControlView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"
#import "PlayerControlDiscItem.h"
#import "PlayerProgressButton.h"
#import "PlayingViewController.h"

#import "AFSoundManager.h"


@interface PlayerControlView()

@property (strong, nonatomic) UIButton *songListBtn;

@property (strong, nonatomic) PlayerProgressButton *progressBtn;

@property (nonatomic, assign) SystemSoundID horn;
@property (nonatomic, assign) BOOL paused;
@property (nonatomic, assign) CGFloat localProgress;
@property (nonatomic, strong) UIImageView *pauseIcon;
@property (nonatomic, assign) NSInteger currentSong;
@property (nonatomic, strong) AFSoundManager *soundManager;

@end

@implementation PlayerControlView
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _songList = [[NSMutableArray alloc]init];
        self.backgroundColor = BACKGROUND_COLOR;
        _currentSong = 0;
        [self configSubView];
    }
    return self;
}

- (void)configSubView {
    _songListView = [[CycleScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 110, 54) animationDuration:0];
    __block PlayerControlView *player = self;

    _songListView.SwipeBlock = ^(NSInteger pageIndex){
        _currentSong = pageIndex;
        [player playMP3AtCurrentIndex];
    };
    _songListView.TapActionBlock = ^(NSInteger pageIndex) {
        PlayingViewController *pvc = [[PlayingViewController alloc]init];
        [SHAREDAPP.navigationController presentViewController:pvc animated:NO completion:^{
            NSLog(@"123");
        }];
    };
    [self addSubview:_songListView];

    
    _songListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _songListBtn.frame = CGRectMake(kScreenWidth - 55 + 7, 7, 40, 40);
    [_songListBtn setImage:[UIImage imageNamed:@"miniplayer_btn_playlist_normal"] forState:UIControlStateNormal];
    [_songListBtn setImage:[UIImage imageNamed:@"miniplayer_btn_playlist_highlight"] forState:UIControlStateHighlighted];
    [self addSubview:_songListBtn];
    
    _progressBtn = [[PlayerProgressButton alloc]initWithFrame:CGRectMake(kScreenWidth - 55*2 + 10, 7, 40, 40)];
    [self addSubview:_progressBtn];
    self.paused = YES;
    _progressBtn.progress = 0;
    _progressBtn.tintColor = ThemeColor_Green;
    _progressBtn.borderWidth = 1.0;
    _progressBtn.lineWidth = 2.0;
    _progressBtn.fillOnTouch = YES;
    
    _pauseIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    _pauseIcon.image = [UIImage imageNamed:@"miniplayer_btn_play_normal"];
    [_pauseIcon setHighlightedImage:[UIImage imageNamed:@"miniplayer_btn_play_highlight"]];
    _progressBtn.centralView = _pauseIcon;

    _progressBtn.fillChangedBlock = ^(PlayerProgressButton *progressButton, BOOL filled, BOOL animated){
        progressButton.centralView.highlighted = YES;
    };


    __block UIImageView *imgView = _pauseIcon;

    _progressBtn.didSelectBlock = ^(PlayerProgressButton *progressButton){
        _paused = !_paused;
        if (_paused == YES) {
            [player pause];
            imgView.image = [UIImage imageNamed:@"miniplayer_btn_play_normal"];
            [imgView setHighlightedImage:[UIImage imageNamed:@"miniplayer_btn_play_highlight"]];
        }else {
            if (_localProgress <= 0) {
                [player playMP3AtCurrentIndex];
            }else{
                [player continuePlay];
            }
            imgView.image = [UIImage imageNamed:@"miniplayer_btn_pause_normal"];
            [imgView setHighlightedImage:[UIImage imageNamed:@"miniplayer_btn_pause_highlight"]];
        }
        imgView.highlighted = NO;
    };
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
}

- (void)pause {
    [[AFSoundManager sharedManager]pause];
}
- (void)continuePlay {
    [[AFSoundManager sharedManager]resume];
}
- (void)playMP3AtCurrentIndex {
    if (_paused == YES) {
        return;
    }
    NSDictionary *dict = [_songList objectAtIndex:_currentSong];
    NSString *file = [dict objectForKey:@"file"];
    [[AFSoundManager sharedManager]startPlayingLocalFileWithName:file andBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"mm:ss"];
    
        
        _localProgress = percentage * 0.01;
        if(finished == YES) {
            self.paused = YES;
        }
    }];
}
- (void)updateProgress:(NSTimer *)timer {
    if (!_paused) {
//        _localProgress = ((int)((_localProgress * 100.0f) + 1.01) % 100) / 100.0f;
        [_progressBtn setProgress:_localProgress];
    }
}
    


- (void)setSongList:(NSMutableArray *)songList {
    if (_songList == songList) {
        return;
    }
    _songList = songList;
    
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
