//
//  YOPlayManager.h
//  YOPlayDemo
//
//  Created by Ian on 2016/11/18.
//  Copyright © 2016年 IAN. All rights reserved.
//  播放管理类

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#include <sys/types.h>
#include <sys/sysctl.h>

// Models
#import "TracksViewModel.h"

@protocol YOPlayManagerDelegate<NSObject>

@optional

// 更新界面
- (void)playManagerUpdateMusic:(id)object ;

// 更新界面时间
- (void)playManagerDidIpdateProgressLabelCurrentTime:(NSTimeInterval )currentTime duration:(NSTimeInterval )duration;

// 更新播放状态
- (void)playManagerDidAVPlayerStatus:(AVPlayerStatus)status;

// 播放完成
- (void)playManagerDidPlaybackFinished;

@end

typedef NS_ENUM(NSUInteger, PlayManagerStatus) {
    PlayManagerPlaying,
    PlayManagerPaused,
    PlayManagerIdle,
    PlayManagerFinished,
    PlayManagerBuffering,
    PlayManagerError
};

@interface YOPlayManager : NSObject

@property (nonatomic, weak) id<YOPlayManagerDelegate> delegate;
@property (nonatomic, strong, readonly) AVPlayer *player;
@property (nonatomic, assign, readonly) BOOL isPlay;
@property (nonatomic, assign, readonly) NSTimeInterval duration;
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;

/** 初始化 */
+ (instancetype)sharedInstance;
/**
  重置当前控制器
 */
- (void)releasePlayer;

/**
 是否正在播放

 @return YES:正在播放  NO：目前空闲
 */
- (BOOL)havePlay;

/**
 播放指定专辑

 @param musicList 当前播放列表
 @param specialIndex 从当前位置开始播放
 */
- (void)playWithMusicList:(NSMutableArray *)musicList
             indexPathRow:(NSInteger)specialIndex;

/**
 根据指定URL播放音频
 @param musicUrl 指定的音频地址
 */
- (void)playerMusicWith:(NSString *)musicUrl;

/**
 对外接口 暂停或者播放音频动作
 */
- (void)playManagerDidPauseMusic;

/**
 播放上一首歌曲
 */
- (void)playManagerDidPreviousMusic;

/**
 播放下一首歌曲
 */
- (void)playManagerDidNextMusic;

/**
 再来一遍
 */
- (void)playManagerDidNextCycle;

@end
