//
//  DanmuView.h
//  Danmu
//
//  Created by zxj－mac on 16/7/31.
//  Copyright © 2016年 zxj－mac. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,MoveStatus) {
    Start,
    Enter,
    End
};
@interface DanmuView : UIView

//弹道
@property (nonatomic,assign)int trajectory;

//弹幕状态回掉
@property (nonatomic,copy) void(^moveStatusBlock)(MoveStatus status);


//初始化弹幕
- (instancetype)initWithComment:(NSString *)comment;

//开始动画
- (void)startAnimation;

//结束动画
- (void)stopAnimation;
@end
