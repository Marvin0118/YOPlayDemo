//
//  PlayViewController.m
//  YOPlayDemo
//
//  Created by Ian on 2016/11/18.
//  Copyright © 2016年 IAN. All rights reserved.
//

#import "PlayViewController.h"

#import "YOPlayManager.h"

#import "NSString+FYString.h"


@interface PlayViewController ()<YOPlayManagerDelegate>

@property (nonatomic, strong) YOPlayManager *playManager;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    YOPlayManager *playManager = [YOPlayManager sharedInstance];
    playManager.delegate = self;
    self.playManager = playManager;
    [playManager playWithMusicList:self.musicArray indexPathRow:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextClicked:(id)sender
{
    [self.playManager playManagerDidNextMusic];
}


- (IBAction)previousClicked:(id)sender
{
    [self.playManager playManagerDidPreviousMusic];
}


- (IBAction)pauseClicked:(id)sender
{
    [self.playManager playManagerDidPauseMusic];
}

////拖动条
//- (IBAction)changeMusicTime:(id)sender {
//
//    _musicIsChange = YES;
//
//}
//- (IBAction)setMusicTime:(id)sender
//{
//
//    CGFloat endTime = CMTimeGetSeconds([_playmanager.player.currentItem duration]);
//    NSInteger dragedSeconds = floorf(self.musicSlider.value * endTime);
//
//    //转换成CMTime才能给player来控制播放进度
//    [_playmanager.player seekToTime:CMTimeMakeWithSeconds(dragedSeconds, 1)];
//
//    _musicIsChange = NO;
//    _musicIsCan = YES;
//}
//- (IBAction)noChangeMusic:(id)sender
//{
//
//    _musicIsChange = NO;
//}

#pragma mark --
#pragma mark -- YOPlayManagerDelegate
// 更新界面
- (void)playManagerUpdateMusic:(id)object
{

}
// 更新界面时间
- (void)playManagerDidIpdateProgressLabelCurrentTime:(NSTimeInterval )currentTime duration:(NSTimeInterval )duration
{
    self.curTimeLabel.text = [NSString timeIntervalToMMSSFormat:currentTime];

    self.toalTimeLabel.text =  [NSString timeIntervalToMMSSFormat:duration];

}
// 更新播放状态
- (void)playManagerDidAVPlayerStatus:(AVPlayerStatus)status
{

}
// 播放完成
- (void)playManagerDidPlaybackFinished
{

}
@end
