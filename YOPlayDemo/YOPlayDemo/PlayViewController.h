//
//  PlayViewController.h
//  YOPlayDemo
//
//  Created by Ian on 2016/11/18.
//  Copyright © 2016年 IAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *musicArray;

@property (nonatomic, weak) IBOutlet UILabel *curTimeLabel;

@property (nonatomic, weak) IBOutlet UILabel *toalTimeLabel;



@end
