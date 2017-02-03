//
//  NSString+XNTimerExtextion.m
//  XNQQMusic
//
//  Created by xunan on 2017/2/3.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "NSString+XNTimerExtextion.h"

@implementation NSString (XNTimerExtextion)

+ (NSString *)stringWithTime:(NSTimeInterval)time {
    NSInteger min = time / 60;
    NSInteger sec = (int)round(time) % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", min, sec];
}

@end
