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
@interface ViewController ()<DanmuManagerDelegate>
@property (nonatomic,strong)DanmuManager *manager;
@end

@implementation ViewController
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
}

//执行添加弹幕事件
- (void)addDanmuView:(DanmuView *)view
{
    view.frame = CGRectMake(kScreenWidth, 300+view.trajectory*40, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    [self.view addSubview:view];
    [view startAnimation];
}

#pragma mark ----- DanmuManagerDelegate
- (void)DanmuViewInitFinish:(DanmuView *)view
{
    [self addDanmuView:view];
}
@end
