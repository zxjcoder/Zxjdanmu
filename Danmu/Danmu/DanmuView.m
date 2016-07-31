//
//  DanmuView.m
//  Danmu
//
//  Created by zxj－mac on 16/7/31.
//  Copyright © 2016年 zxj－mac. All rights reserved.
//

#import "DanmuView.h"
#define Padding 10
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define duration 4.0
@interface DanmuView ()

@property (nonatomic,strong)UILabel  *commentLabel;

@end

@implementation DanmuView
//初始化弹幕
- (instancetype)initWithComment:(NSString *)comment
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];

        //计算字符串宽度
        NSDictionary *attstr = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGFloat width = [comment sizeWithAttributes:attstr].width;

        self.bounds = CGRectMake(0, 0, width + 2*Padding, 30);

        self.commentLabel.text = comment;
        self.commentLabel.frame = CGRectMake(Padding, 0, width, 30);
        [self addSubview:self.commentLabel];
    }
    return self;
}

//开始动画
- (void)startAnimation
{

    //根据弹幕长度执行动画效果

    //v = s/t 时间相同,弹幕长,速度快
    CGFloat totalWidth = kScreenWidth + self.bounds.size.width;


    //弹幕开始
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Start);
    }

    //v = s/t
    CGFloat speed = totalWidth/duration;
    CGFloat enterDuration = self.bounds.size.width/speed;

    [self performSelector:@selector(EnterScreen) withObject:nil afterDelay:enterDuration];

//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    /*
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(enterDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.moveStatusBlock) {
            self.moveStatusBlock(Enter);
        }
    });
     */
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x =  frame.origin.x - totalWidth;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.moveStatusBlock) {
            self.moveStatusBlock(End);
        }
    }];
}

//结束动画
- (void)stopAnimation
{
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}


//label懒加载
- (UILabel *)commentLabel
{
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentLabel.font =  [UIFont systemFontOfSize:14];
        _commentLabel.textColor  = [UIColor whiteColor];
        _commentLabel.textAlignment = 1;
    }
    return _commentLabel;
}

- (void)EnterScreen
{
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Enter);
    }
}
@end
