//
//  DanmuView.h
//  Danmu
//
//  Created by zxj－mac on 16/7/31.
//  Copyright © 2016年 zxj－mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DanmuView;
typedef NS_ENUM(NSInteger,MoveStatus) {
    Start,
    Enter,
    End
};

//代理弹幕状态回调
@protocol DanmuViewDelegate <NSObject>

@optional
- (void)DanmuViewStatus:(MoveStatus)status danmuView:(DanmuView *)view;

@end
@interface DanmuView : UIView

//弹道
@property (nonatomic,assign)int trajectory;

//弹幕状态回掉
@property (nonatomic,copy) void(^moveStatusBlock)(MoveStatus status);

@property (nonatomic,weak)id<DanmuViewDelegate> delegate;
//初始化弹幕
- (instancetype)initWithComment:(NSString *)comment;

//开始动画
- (void)startAnimation;

//结束动画
- (void)stopAnimation;
@end
