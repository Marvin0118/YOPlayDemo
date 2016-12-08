//
//  TracksViewModel.h
//  YOPlayDemo
//
//  Created by Ian on 2016/11/18.
//  Copyright © 2016年 IAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TracksViewModel : NSObject

/** 返回专辑标题 */
@property (nonatomic,strong) NSString *albumTitle;
/** 返回专辑播放次数 */
@property (nonatomic,strong) NSString *albumPlays;
/** 返回专辑图片链接地址 */
@property (nonatomic,strong) NSURL *albumCoverURL;
@property (nonatomic,strong) NSURL *albumCoverLargeURL;
/** 返回专辑头像地址 */
@property (nonatomic,strong) NSURL *albumIconURL;
/** 返回专辑昵称 */
@property (nonatomic,strong) NSString *albumNickName;


@end
