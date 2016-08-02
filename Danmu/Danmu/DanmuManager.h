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

@required
//创建弹幕完成回调(delegate)
- (void)DanmuViewInitFinish:(DanmuView *)view;

@optional
//弹幕被点击时回调
//- (void)ManagerDanmuViewDidSelected:(DanmuView *)view Comment:(NSString *)comment;
@end
@interface DanmuManager : NSObject

//创建弹幕完成回调(block)
@property (nonatomic,copy) void (^generateBlock)( DanmuView *view);

@property (nonatomic,weak)id<DanmuManagerDelegate>  delegate;

//弹幕数据源
@property (nonatomic,strong)NSMutableArray *dataSource;
//弹幕使用时的数组变量
@property (nonatomic,strong)NSMutableArray *DanmuComments;
//存储弹幕View的数组
@property (nonatomic,strong)NSMutableArray *DanmuViews;
//弹幕开始
- (void)start;

//弹幕停止
- (void)stop;

@end
