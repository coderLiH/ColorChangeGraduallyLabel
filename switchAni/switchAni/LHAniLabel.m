//
//  LHAniLabel.m
//  switchAni
//
//  Created by 李允 on 15/12/7.
//  Copyright © 2015年 liyun. All rights reserved.
//

#import "LHAniLabel.h"

@interface LHAniLabel ()
@property (nonatomic, strong) dispatch_source_t timer;
@end
@implementation LHAniLabel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.aniDuration = 0.1;
    }
    return self;
}

- (void)awakeFromNib {
    self.aniDuration = 0.1;
}

- (void)setToColor:(UIColor *)toColor {
    _toColor = toColor;
    
    CGColorRef fromcolor = [self.fromColor CGColor];
    size_t fromNumComponents = CGColorGetNumberOfComponents(fromcolor);
    if (fromNumComponents == 4) {
        const CGFloat *components = CGColorGetComponents(fromcolor);
        self.fR = components[0];
        self.fG = components[1];
        self.fB = components[2];
    }
    
    CGColorRef tocolor = [self.toColor CGColor];
    size_t toNumComponents = CGColorGetNumberOfComponents(tocolor);
    if (toNumComponents == 4) {
        const CGFloat *components = CGColorGetComponents(tocolor);
        self.tR = components[0];
        self.tG = components[1];
        self.tB = components[2];
    }
}

- (void)autoChangeTextColor:(UIColor *)targetColor {
    
    CGColorRef fromcolor = [self.textColor CGColor];
    size_t fromNumComponents = CGColorGetNumberOfComponents(fromcolor);
    CGFloat fR, fG, fB;
    if (fromNumComponents == 4) {
        const CGFloat *components = CGColorGetComponents(fromcolor);
        fR = components[0];
        fG = components[1];
        fB = components[2];
    }
    
    CGColorRef color = [targetColor CGColor];
    size_t numComponents = CGColorGetNumberOfComponents(color);
    CGFloat R, G, B;
    if (numComponents == 4) {
        const CGFloat *components = CGColorGetComponents(color);
        R = components[0];
        G = components[1];
        B = components[2];
    }
    NSInteger total = 6*self.aniDuration/0.1 + 1;
    
    CGFloat eveR = (R - fR) / total;
    CGFloat eveG = (G - fG) / total;
    CGFloat eveB = (B - fB) / total;
    __block CGFloat toR = fR;
    __block CGFloat toG = fG;
    __block CGFloat toB = fB;
    
    if (!_timer) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    }
    
    NSTimeInterval period = 1/60.; //设置时间间隔
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //在这里执行事件
            toR += eveR;
            toG += eveG;
            toB += eveB;
            
            self.textColor = [UIColor colorWithRed:toR green:toG blue:toB alpha:1.];
        });
    });
    if (!self.userInteractionEnabled) {
        return;
    }
    dispatch_resume(_timer);
    self.userInteractionEnabled = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.aniDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_suspend(_timer);
        self.userInteractionEnabled = YES;
    });
    
}

@end
