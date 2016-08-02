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

        self.userInteractionEnabled = NO;
        self.commentLabel.text = comment;
        self.commentLabel.frame = CGRectMake(Padding, 0, width, 30);

//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapAction:)];
//        [self.commentLabel addGestureRecognizer:tap];
//        [self addGestureRecognizer:tap];
        [self addSubview:self.commentLabel];
    }
    return self;
}

//开始动画
- (void)startAnimation
{

    //根据弹幕长度执行动画效果

    //v = s/t 时间相同,弹幕长,速度快

    //屏幕+弹幕的长度
    CGFloat totalWidth = kScreenWidth + self.bounds.size.width;


    //弹幕开始
    if ([self.delegate respondsToSelector:@selector(DanmuViewStatus:danmuView:)]) {
        [self.delegate DanmuViewStatus:Start danmuView:self];
    }
//    if (self.moveStatusBlock) {
//        self.moveStatusBlock(Start);
//    }

    //v = s/t
    CGFloat speed = totalWidth/duration;
    CGFloat enterDuration = self.bounds.size.width/speed;

    [self performSelector:@selector(EnterScreen) withObject:nil afterDelay:enterDuration];

    /*
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(enterDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.moveStatusBlock) {
            self.moveStatusBlock(Enter);
        }
    });
     */
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
//        NSLog(@"frame.origin.x = %lf  totalWidth = %lf",frame.origin.x,totalWidth);
        frame.origin.x =  frame.origin.x - totalWidth;
//        NSLog(@"frame.origin.x = %lf  totalWidth = %lf",frame.origin.x,totalWidth);
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(DanmuViewStatus: danmuView:)]) {
            [self.delegate DanmuViewStatus:End danmuView:self];
        }
//        if (self.moveStatusBlock) {
//            self.moveStatusBlock(End);
//        }
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
        _commentLabel.backgroundColor = [UIColor blueColor];
        _commentLabel.userInteractionEnabled = NO;
        _commentLabel.textAlignment = 1;
    }
    return _commentLabel;
}

//进入屏幕
- (void)EnterScreen
{
    if ([self.delegate respondsToSelector:@selector(DanmuViewStatus: danmuView:)]) {
        [self.delegate DanmuViewStatus:Enter danmuView:self];
    }
//    if (self.moveStatusBlock) {
//        self.moveStatusBlock(Enter);
//    }
}
/* 动画时,Tap不会响应
//点击事件
- (void)TapAction:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(DanmuViewDidSelected:Comment:)]) {
        [self.delegate DanmuViewDidSelected:self Comment:self.commentLabel.text];
    }
}
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"点击了 %@",self.commentLabel.text);
}
@end
