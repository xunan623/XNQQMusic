//
//  XNLrcLine.m
//  XNQQMusic
//
//  Created by xunan on 2017/2/6.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNLrcLine.h"

@implementation XNLrcLine


+ (instancetype)lrcLineString:(NSString *)lrcLineString {
    return [[self alloc] initWithLrcLineString:lrcLineString];
}

- (instancetype)initWithLrcLineString:(NSString *)lrcLineString {
    if (self = [super init]) {
        // [01:32.64]宁愿相信我们前世有约
        NSArray *lrcArray = [lrcLineString componentsSeparatedByString:@"]"];
        self.text = lrcArray[1];
        
        self.time = [self timeWithString:[lrcArray[0] substringFromIndex:1]];
        
    }
    return self;
}

- (NSTimeInterval)timeWithString:(NSString *)timeString {
    NSInteger min = [[timeString componentsSeparatedByString:@":"][0] integerValue];
    NSInteger sec = [[timeString substringWithRange:NSMakeRange(3, 2)] integerValue];
    NSInteger hs = [[timeString componentsSeparatedByString:@"."][1] integerValue];
    
    return min * 60 + sec + hs * 0.01;
}

@end
