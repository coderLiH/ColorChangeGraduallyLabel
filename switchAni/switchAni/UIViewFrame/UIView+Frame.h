//
//  UIView+Frame.h
//  ItheimaLottery
//
//  Created by apple on 14/11/8.
//  Copyright (c) 2014年 iThinker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

// 在分类里面自动生成get,set方法
@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

@end
