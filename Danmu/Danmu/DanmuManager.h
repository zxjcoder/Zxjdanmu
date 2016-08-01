//
//  DanmuManager.h
//  Danmu
//
//  Created by zxj－mac on 16/7/31.
//  Copyright © 2016年 zxj－mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DanmuView;
@protocol DanmuManagerDelegate <NSObject>

//创建弹幕完成回调(delegate)
- (void)DanmuViewInitFinish:(DanmuView *)view;

@end
@interface DanmuManager : NSObject

//创建弹幕完成回调(block)
@property (nonatomic,copy) void (^generateBlock)( DanmuView *view);

@property (nonatomic,weak)id<DanmuManagerDelegate>  delegate;
//弹幕开始
- (void)start;

//弹幕停止
- (void)stop;

@end
