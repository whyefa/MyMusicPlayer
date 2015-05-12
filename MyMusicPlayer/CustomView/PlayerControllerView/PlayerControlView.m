//
//  PlayerControlView.m
//  MyMusicPlayer
//
//  Created by iOS on 15/5/11.
//  Copyright (c) 2015年 rc. All rights reserved.
//

#import "PlayerControlView.h"
#import "PlayerControlDiscItem.h"
#import "PlayerProgressButton.h"
#import <AudioToolbox/AudioToolbox.h>
#import "AFSoundManager.h"
@interface PlayerControlView()


@property (strong, nonatomic) UIButton *songListBtn;

@property (strong, nonatomic) PlayerProgressButton *progressBtn;

@property (nonatomic, assign) SystemSoundID horn;
@property (nonatomic, assign) BOOL paused;
@property (nonatomic, assign) CGFloat localProgress;
@property (nonatomic, strong) UIImageView *pauseIcon;
@property (nonatomic) NSInteger currentSong;
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
    __block PlayerControlView *control = self;
    _songListView.SwipeBlock = ^(NSInteger currentIndex){
        [control playMP3WithSongIndex:currentIndex];
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
    
    
    
    _progressBtn.centralView = _pauseIcon;
    __block UIImageView *imgView = _pauseIcon;

    _progressBtn.fillChangedBlock = ^(PlayerProgressButton *progressButton, BOOL filled, BOOL animated){

    };
    
    _progressBtn.progressChangedBlock = ^(PlayerProgressButton *progressButton, CGFloat progress){
//        [(UILabel *)progressButton.centralView setText:[NSString stringWithFormat:@"%2.0f%%", progress * 100]];
    };
    
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"listen" ofType:@"mp3"];
    NSURL *pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &_horn);
    
//    __block UInt32 horn = _horn;
    __block PlayerControlView *player = self;
    _progressBtn.didSelectBlock = ^(PlayerProgressButton *progressButton){
//        AudioServicesPlaySystemSound(horn);
        _paused = !_paused;
        if (_paused == YES) {
            [player pause];
            imgView.image = [UIImage imageNamed:@"miniplayer_btn_play_normal"];
            [imgView setHighlightedImage:[UIImage imageNamed:@"miniplayer_btn_play_highlight"]];
        }else {
            [player playMP3WithSongIndex:_currentSong];
            imgView.image = [UIImage imageNamed:@"miniplayer_btn_pause_normal"];
            [imgView setHighlightedImage:[UIImage imageNamed:@"miniplayer_btn_pause_highlight"]];
        }
        imgView.highlighted = NO;
    };
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
}
- (UIImage*)getCoverImage {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"listen" ofType:@"mp3"];
    NSURL *mp3URL = [NSURL fileURLWithPath:path];
    AVURLAsset *mp3Asset = [AVURLAsset URLAssetWithURL:mp3URL options:nil];
    
    for (AVMetadataItem *metaDataItem in [mp3Asset commonMetadata]) {
        
        if ([[metaDataItem commonKey] isEqualToString:@"artwork"]) {
            
            return [UIImage imageWithData:[(NSDictionary*)metaDataItem.value objectForKey:@"data"]];
            
        }
    }
    
    return nil;
    
}
- (void)getSongDetail {
    NSMutableDictionary *retDic = [[NSMutableDictionary alloc] init];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"listen" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    AVURLAsset *mp3Asset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    
    for (NSString *format in [mp3Asset availableMetadataFormats]) {
        for (AVMetadataItem *metadataItem in [mp3Asset metadataForFormat:format]) {
            
            if(metadataItem.commonKey)
                [retDic setObject:metadataItem.value forKey:metadataItem.commonKey];
            
        }
    }
}
- (void)pause {
    [[AFSoundManager sharedManager]pause];
}
- (void)playMP3WithSongIndex:(NSInteger)currentSong {
//    [_songListView resetContent];
    NSDictionary *dict = [_songList objectAtIndex:currentSong];
    NSString *file = [dict objectForKey:@"file"];
    [[AFSoundManager sharedManager]startPlayingLocalFileWithName:file andBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"mm:ss"];
        
//        NSDate *elapsedTimeDate = [NSDate dateWithTimeIntervalSince1970:elapsedTime];
//        _elapsedTime.text = [formatter stringFromDate:elapsedTimeDate];
//        
//        NSDate *timeRemainingDate = [NSDate dateWithTimeIntervalSince1970:timeRemaining];
//        _timeRemaining.text = [formatter stringFromDate:timeRemainingDate];
        
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
