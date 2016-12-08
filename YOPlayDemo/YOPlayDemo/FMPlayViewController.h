//
//  FMPlayViewController.h
//  YOPlayDemo
//
//  Created by Ian on 2016/11/18.
//  Copyright © 2016年 IAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#include <sys/types.h>
#include <sys/sysctl.h>


@interface FMPlayViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *musicList;
@property (nonatomic, assign) NSInteger specialIndex;
@property (nonatomic, assign) BOOL dontReloadMusic;
@property (nonatomic, assign) BOOL isNotPresenting;

@end
