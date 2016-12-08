//
//  FMPlayViewController.m
//  YOPlayDemo
//
//  Created by Ian on 2016/11/18.
//  Copyright © 2016年 IAN. All rights reserved.
//

#import "FMPlayViewController.h"

@interface FMPlayViewController ()

@property (nonatomic, assign, readwrite) BOOL isPlay;
@property (nonatomic, strong, readwrite) AVPlayer *player;

@property (nonatomic, strong) AVPlayerItem *currentPlayerItem;
@property (nonatomic, assign) NSInteger rowNumber;

// 当前音频时长
@property (nonatomic, assign) CGFloat total;
@property (nonatomic, assign) BOOL newPlayerItem;

@property (nonatomic) BOOL musicIsPlaying;
@property (nonatomic) NSInteger currentIndex;

@end

@implementation FMPlayViewController

+ (instancetype)sharedInstance {
    static FMPlayViewController *_sharedMusicVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedMusicVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"music"];
    });

    return _sharedMusicVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
