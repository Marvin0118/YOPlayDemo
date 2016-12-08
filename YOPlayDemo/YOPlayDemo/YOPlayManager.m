//
//  YOPlayManager.m
//  YOPlayDemo
//
//  Created by Ian on 2016/11/18.
//  Copyright © 2016年 IAN. All rights reserved.
//

#import "YOPlayManager.h"

static YOPlayManager *_instance = nil;

@interface YOPlayManager ()

@property (nonatomic, assign, readwrite) BOOL isPlay;
@property (nonatomic, strong, readwrite) AVPlayer *player;

@property (nonatomic, strong) AVPlayerItem *currentPlayerItem;
@property (nonatomic, assign) NSInteger rowNumber;
// 当前音频时长
@property (nonatomic, assign) CGFloat total;
@property (nonatomic, assign) BOOL newPlayerItem;

// 播放列表
@property (nonatomic, strong) NSMutableArray *musicList;

@property (nonatomic, assign, readwrite) NSTimeInterval duration;
@property (nonatomic, assign, readwrite) NSTimeInterval currentTime;


@end


@implementation YOPlayManager


/** 初始化 */
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 监听播放状态
        [self.player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        // 支持后台播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        // 激活
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        // 开始监控
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
    return self;
}

/** 清空属性 */
- (void)releasePlayer
{
    if (!self.currentPlayerItem) {
        return;
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player removeObserver:self forKeyPath:@"status"];

    self.currentPlayerItem = nil;
    self.newPlayerItem = YES;
}

/** 是否在播放 */
- (BOOL)havePlay
{
    return _isPlay;
}


/**
 @return 当前音频总时间
 */
- (NSTimeInterval)duration
{
    if (!_currentPlayerItem) {
        return CMTimeGetSeconds([self.player.currentItem duration]);
    }
    return 0;
}

/**
 @return 当前音频播放时间
 */
- (NSTimeInterval)currentTime
{
    if (!_currentPlayerItem) {
        return CMTimeGetSeconds([self.player.currentItem currentTime]);
    }
    return 0;
}

/**
 监控播放状态
 */
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    AVPlayer *player = (AVPlayer *)object;
    if ([keyPath isEqualToString:@"status"])
    {
        if ([self.delegate respondsToSelector:@selector(playManagerDidAVPlayerStatus:)])
        {
            [self.delegate playManagerDidAVPlayerStatus:player.status];
        }
    }
}

/**
 装载专辑
 @param musicList 播放列表
 @param specialIndex 指定当前播放位置
 */
- (void)playWithMusicList:(NSMutableArray *)musicList
             indexPathRow:(NSInteger)specialIndex;
{
    self.musicList = musicList;
    self.newPlayerItem = YES;

    if (specialIndex < 0) {
        self.rowNumber = 0;
    }else if (specialIndex < self.rowNumber-1) {
        self.rowNumber = specialIndex;
    }else{
        self.rowNumber = 0;
    }
    //AVPlayer的缓存播放实现比较繁琐，可自行查找AVAssetResourceLoader资料
    NSString *urlPath = [musicList objectAtIndex:self.rowNumber];
    NSURL *musicURL =  [NSURL URLWithString:urlPath];
    self.currentPlayerItem = [AVPlayerItem playerItemWithURL:musicURL];

    // 播放指定url
    [self playerMusicWith:urlPath];
}

/**
 监听播放进度
 */
-(void)addMusicTimeMake
{
    __weak YOPlayManager *weakSelf = self;
    //监听
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        YOPlayManager *innerSelf = weakSelf;
        //控制中心
        [innerSelf updateLockedScreenMusic];


        // 更新进度
        if (innerSelf.newPlayerItem == YES) {
            AVPlayerItem *newItem = innerSelf.player.currentItem;
            if (!isnan(CMTimeGetSeconds([newItem duration]))) {
                innerSelf.total = CMTimeGetSeconds([newItem duration]);
                innerSelf.newPlayerItem = NO;
            }
         }
        if ([innerSelf.delegate respondsToSelector:@selector(playManagerDidIpdateProgressLabelCurrentTime:duration:)])
        {
            // 当前时长
            NSTimeInterval current=CMTimeGetSeconds([innerSelf.player.currentItem currentTime]);
            [innerSelf.delegate playManagerDidIpdateProgressLabelCurrentTime:current duration:innerSelf.total];
        }
    }];
}

#pragma mark --
#pragma mark -- 播放动作

/**
 播放完成
 @param notification :self.currentPlayerItem
 */
- (void)playbackFinished:(NSNotification *)notification
{
    if ([self.delegate respondsToSelector:@selector(playManagerDidPlaybackFinished)]) {

        if (self.rowNumber+1 < self.musicList.count){
            // 播放完成继续下一首
            [self playNextMusicAction];
        }else{
            NSLog(@"当前是最后一首歌曲哈");
            [self.delegate playManagerDidPlaybackFinished];
        }
    }
}

/**
 播放上一首
 */
- (void)playPreviousMusicAction
{
    if (_currentPlayerItem){
        if (self.rowNumber > 0) {
            self.rowNumber--;
        }else{
            NSLog(@"当前是第一曲啦");
            return;
        }
        self.newPlayerItem = YES;
        [self playerMusicWith:self.musicList[self.rowNumber]];
    }
}

/**
  播放下一首
 */
- (void)playNextMusicAction
{
    if (_currentPlayerItem) {

        if (self.rowNumber < self.musicList.count-1) {
            self.rowNumber++;
        }else{
            NSLog(@"当前是最后一曲啦");
            return;
        }

        self.newPlayerItem = YES;

        // 播放下一首
        [self playerMusicWith:self.musicList[self.rowNumber]];
    }
}

/**
 再来一遍
 */
- (void)playAgainAction
{
    if (_player) {
        [_player seekToTime:CMTimeMake(0, 1)];
        _isPlay = YES;
        [_player play];
    }
}


/**
 根据指定URL播放音频
 @param musicUrl 知道的音频地址
 */
- (void)playerMusicWith:(NSString *)musicUrl
{
    NSURL *musicURL = [NSURL URLWithString:musicUrl];
    self.currentPlayerItem = [AVPlayerItem playerItemWithURL:musicURL];
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.currentPlayerItem];
    [self addMusicTimeMake];
    _isPlay = YES;
    [_player play];

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

    [notificationCenter removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.currentPlayerItem];
    [notificationCenter addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.currentPlayerItem];
}


#pragma mark --
#pragma mark -- 锁屏时候的设置，效果需要在真机上才可以看到
- (void)updateLockedScreenMusic
{
    // 播放信息中心
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];

    // 初始化播放信息
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    // 专辑名称
    info[MPMediaItemPropertyAlbumTitle] = @"专辑名称";
    // 歌手
    info[MPMediaItemPropertyArtist] = @"歌手";
    //
    info[MPMediaItemPropertyTitle] = @"歌曲名称";
    // 设置图片
//    info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[self playCoverImage]];
    // 设置持续时间（歌曲的总时间）
    [info setObject:[NSNumber numberWithFloat:CMTimeGetSeconds([self.player.currentItem duration])] forKey:MPMediaItemPropertyPlaybackDuration];
    // 设置当前播放进度
    [info setObject:[NSNumber numberWithFloat:CMTimeGetSeconds([self.player.currentItem currentTime])] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];

    // 切换播放信息
    center.nowPlayingInfo = info;
}

/*************************** 外部事件接口 *************************/
/************************************************************/

/** 暂停与播放(互斥的) */
- (void)playManagerDidPauseMusic
{
    if (!self.currentPlayerItem) {
        return;
    }

    if (_player.rate) {
        _isPlay = NO;
        [_player pause];

    }else{
        _isPlay = YES;
        [_player play];
    }
}

/** 上一曲 */
- (void)playManagerDidPreviousMusic
{
    [self playPreviousMusicAction];

}
/** 下一曲 */
- (void)playManagerDidNextMusic
{
    [self playNextMusicAction];

}
/** 循环 */
- (void)playManagerDidNextCycle
{
    [self playAgainAction];
}

@end
