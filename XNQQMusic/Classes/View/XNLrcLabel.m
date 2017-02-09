//
//  XNLrcLabel.m
//  XNQQMusic
//
//  Created by xunan on 2017/2/9.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNLrcLabel.h"

@implementation XNLrcLabel


- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    CGRect fillRect = CGRectMake(0, 0, self.bounds.size.width * self.progress, self.bounds.size.height);
    
    [[UIColor greenColor] set];
    
    UIRectFillUsingBlendMode(fillRect, kCGBlendModeSourceIn);
}


@end
