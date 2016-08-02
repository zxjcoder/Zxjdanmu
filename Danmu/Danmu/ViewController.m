//
//  ViewController.m
//  Danmu
//
//  Created by zxj－mac on 16/7/31.
//  Copyright © 2016年 zxj－mac. All rights reserved.
//

#import "ViewController.h"
#import "DanmuView.h"
#import "DanmuManager.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define UIDeviceOrientationIsPortrait(orientation)  ((orientation) == UIDeviceOrientationPortrait || (orientation) == UIDeviceOrientationPortraitUpsideDown)
#define UIDeviceOrientationIsLandscape(orientation) ((orientation) == UIDeviceOrientationLandscapeLeft || (orientation) == UIDeviceOrientationLandscapeRight)
@interface ViewController ()<DanmuManagerDelegate>
@property (nonatomic,strong)DanmuManager *manager;
@end

@implementation ViewController
{
    NSInteger _index;
}
- (IBAction)startAction:(UIButton *)sender {
    [self.manager start];
}
- (IBAction)stopAction:(UIButton *)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [[DanmuManager alloc] init];

    /*
    //block方法
    __weak typeof(self) weakSelf = self;
    self.manager.generateBlock = ^(DanmuView *view){

        [weakSelf addDanmuView:view];
    };
     */
    //代理方法
    self.manager.delegate = self;
    [self.manager.dataSource addObjectsFromArray:@[
                                                   @"弹幕1~~~~~~~~~",
                                                   @"弹幕2~~~~~~~~~",
                                                   @"弹幕3~~~~~~~~~",
                                                   @"弹幕4~~~~~~~~~",
                                                   @"弹幕5~~~~~~~~~",
                                                   @"弹幕6~~~~~~~~~",
                                                   @"弹幕7~~~~~~~~~",
                                                   @"弹幕8~~~~~~~~~",
                                                   @"弹幕9~~~~~~~~~",
                                                   @"弹幕10~~~~~~~~~",
                                                   @"弹幕11~~~~~~~~~",
                                                   @"弹幕12~~~~~~~~~",
                                                   @"弹幕13~~~~~~~~~",
                                                   @"弹幕14~~~~~~~~~",]];

    _index = 0;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(addDanmuAction:) userInfo:nil repeats:YES];

}
- (void)addDanmuAction:(id)sender
{
    _index++;
    [self.manager.dataSource addObjectsFromArray:@[[NSString stringWithFormat:@"弹幕%ld~~~~~~~~~",_index+14],]];
    [self.manager.DanmuComments addObjectsFromArray:@[[NSString stringWithFormat:@"弹幕%ld~~~~~~~~~",_index+14],]];
}

//执行添加弹幕事件
- (void)addDanmuView:(DanmuView *)view
{
    CGFloat height = 0;
    //判断屏幕方向
    if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice]orientation])) {
        height = 300;
    }
    else
        height = 100;

    view.frame = CGRectMake(kScreenWidth, height+view.trajectory*40, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    [self.view addSubview:view];
    [view startAnimation];
}

#pragma mark ----- DanmuManagerDelegate
- (void)DanmuViewInitFinish:(DanmuView *)view
{
    [self addDanmuView:view];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [touches anyObject];
//    NSLog(@"%ld",touch.tapCount);
    // 获取点击点
    CGPoint point = [[touches anyObject] locationInView:self.view];

    for (DanmuView *view in self.manager.DanmuViews) {
//     获取tmpView的layer当前的位置
        CGPoint presentationPosition = [[view.layer presentationLayer] position];
    
        // 判断位置，让tmpView接受点击事件
        if (point.x > presentationPosition.x - view.frame.size.width/2.0 && point.x < presentationPosition.x + view.frame.size.width/2.0 &&
            point.y > presentationPosition.y - view.frame.size.height/2.0 && point.y < presentationPosition.y + view.frame.size.height/2.0) {
            [view touchesBegan:touches withEvent:event];

        }
    }
    // 获取tmpView的layer当前的位置
//    CGPoint presentationPosition = [[tmpView.layer presentationLayer] position];
//
//    // 判断位置，让tmpView接受点击事件
//    if (point.x > presentationPosition.x - 50 && point.x < presentationPosition.x + 50 &&
//        point.y > presentationPosition.y - 50 && point.y < presentationPosition.y + 50) {
//        [tmpView touchesBegan:touches withEvent:event];
//    }
}
@end
