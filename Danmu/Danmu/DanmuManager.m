//
//  DanmuManager.m
//  Danmu
//
//  Created by zxj－mac on 16/7/31.
//  Copyright © 2016年 zxj－mac. All rights reserved.
//

#import "DanmuManager.h"
#import "DanmuView.h"

@interface DanmuManager ()

//弹幕数据源
@property (nonatomic,strong)NSMutableArray *dataSource;
//弹幕使用时的数组变量
@property (nonatomic,strong)NSMutableArray *DanmuComments;

//存储弹幕View的数组
@property (nonatomic,strong)NSMutableArray *DanmuViews;

@end
@implementation DanmuManager


- (NSString *)nextComment
{
    if (self.DanmuComments.count == 0) {
        return nil;
    }
    NSString *comment = [self.DanmuComments firstObject];
    if (!comment) {
        [self.DanmuComments removeObject:comment];
    }
   return comment;
}
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
//        _dataSource = [NSMutableArray arrayWithCapacity:0];
        _dataSource = [NSMutableArray arrayWithArray:@[
                                                       @"弹幕1~~~~~~~~~",
                                                       @"弹幕1~~~~~弹幕2~~~~",
                                                       @"弹幕1~~~~~弹幕2~~~~弹幕3"]];
    }
    return _dataSource;
}
-(NSMutableArray *)DanmuComments
{
    if (!_DanmuComments) {
        _DanmuComments = [NSMutableArray arrayWithCapacity:0];
    }
    return _DanmuComments;
}
-(NSMutableArray *)DanmuViews
{
    if (!_DanmuViews) {
        _DanmuViews = [NSMutableArray arrayWithCapacity:0];
    }
    return _DanmuViews;
}
//停止
- (void)stop
{

}

//开始
-(void)start
{
    [self.DanmuComments removeAllObjects];
    [self.DanmuComments addObjectsFromArray:self.dataSource];

    [self initDanmuComment];
}

//初始化弹幕,随机分配弹幕轨迹
- (void)initDanmuComment
{
    NSMutableArray *traJectorys = [NSMutableArray arrayWithArray:@[@(0),@(1),@(2)]];
    for (int i = 0; i < 3; i++) {
        if (self.DanmuComments.count >0) {
            //随机数取弹幕轨迹
            NSInteger index = arc4random()%traJectorys.count;
            int traJectory = [traJectorys[index] intValue];
            [traJectorys removeObjectAtIndex:index];

            //从弹幕数组中逐一取出弹幕数据
            NSString *comment = [self.DanmuComments firstObject];
            [self.DanmuComments removeObjectAtIndex:0];

            //创建弹幕View
            [self createDanmuViewWithComment:comment trajectory:traJectory];
        }
    }
}

//创建弹幕
- (void)createDanmuViewWithComment:(NSString *)comment trajectory:(int )trajectory
{
    DanmuView *view = [[DanmuView alloc] initWithComment:comment];
    view.trajectory = trajectory;
    [self.DanmuViews addObject:view];

    __weak typeof(view) weakView = view;
    __weak typeof(self) weakSelf = self;

    //开始动画后,此处给回调
    view.moveStatusBlock = ^(MoveStatus status){
        switch (status) {
            case Start:
            {
                //弹幕开始进入屏幕,将View加入弹幕管理的DanmuViews中
                [weakSelf.DanmuViews addObject:weakView];

                break;

            }
            case Enter:
            {

                //弹幕完全进入屏幕,判断是否有其他内容,如果有,则在该弹幕轨迹中创建一个弹幕
                NSString *comment = [weakSelf nextComment];
                if (comment) {
                    [weakSelf createDanmuViewWithComment:comment trajectory:trajectory];
                }

                break;

            }
            case End:
            {
                //弹幕完全飞出屏幕 后,需要从DanmuViews中完全删除
                if ([weakSelf.DanmuViews containsObject:weakView]) {
                    [weakView stopAnimation];
                    [weakSelf.DanmuViews removeObject:weakView];
                }
                if (weakSelf.DanmuViews.count == 0) {
                    //说明屏幕上已经没有弹幕了,开始循环滚动
                    [weakSelf start];
                }

                break;

            }
            default:
                break;
        }
        //已出屏幕后销毁弹幕
        [weakView stopAnimation];
        [weakSelf.DanmuViews removeObject:weakView];
    };
    if ([self.delegate respondsToSelector:@selector(DanmuViewInitFinish:)]) {
        [self.delegate DanmuViewInitFinish:view];
    }
    else if (self.generateBlock) {
        self.generateBlock(view);
    }
}
@end
