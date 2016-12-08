//
//  ViewController.m
//  YOPlayDemo
//
//  Created by Ian on 2016/11/18.
//  Copyright © 2016年 IAN. All rights reserved.
//

#import "ViewController.h"
#import "PlayViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PlayViewController *controller = segue.destinationViewController;
    controller.musicArray = @[@"https://test3.myweb114.com/uploads/hls/58260c25665c1/outputlist.m3u8",@"http://igetoss.cdn.igetget.com/aac/201609/24/64000_201609241712036262399681.m4a?OSSAccessKeyId=jNaxWIooBUXUVPJM&Expires=1479658822&Signature=5D2QS62wOTiRFKWFfsflv%2FzNQHI%3D",@"http://igetoss.cdn.igetget.com/aac/201608/31/64000_201608311743341954606195.m4a?OSSAccessKeyId=jNaxWIooBUXUVPJM&Expires=1479658822&Signature=pbSNtAtYXfCUZAzlt37CbtdA9x4%3D",@"http://igetoss.cdn.igetget.com/aac/201611/02/64000_201611021809492077941950.m4a?OSSAccessKeyId=jNaxWIooBUXUVPJM&Expires=1481862053&Signature=u%2F5vakUus2Mfk5DkJFmjwibSOVg%3D",@"http://igetoss.cdn.igetget.com/aac/201611/09/64000_201611092235367087454648.m4a?OSSAccessKeyId=jNaxWIooBUXUVPJM&Expires=1481862053&Signature=WdH3%2F9P6LYRGFvofSexkKh0GnaU%3D"].mutableCopy;

}

@end
