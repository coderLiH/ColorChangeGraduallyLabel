//
//  LHAniLabel.h
//  switchAni
//
//  Created by 李允 on 15/12/7.
//  Copyright © 2015年 liyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHAniLabel : UILabel
@property (nonatomic, assign) CGFloat aniDuration;
- (void)autoChangeTextColor:(UIColor *)targetColor;

@property (nonatomic, strong) UIColor *fromColor;
@property (nonatomic, strong) UIColor *toColor;
@property (nonatomic, assign) CGFloat fR;
@property (nonatomic, assign) CGFloat fG;
@property (nonatomic, assign) CGFloat fB;

@property (nonatomic, assign) CGFloat tR;
@property (nonatomic, assign) CGFloat tG;
@property (nonatomic, assign) CGFloat tB;


@end
