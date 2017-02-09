//
//  XNLrcTool.m
//  XNQQMusic
//
//  Created by xunan on 2017/2/4.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNLrcTool.h"
#import "XNLrcLine.h"

@implementation XNLrcTool

+ (NSArray *)setupLrcWithString:(NSString *)lrcString {
    // 1.找到文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:lrcString ofType:nil];
    
    // 2.获取歌词
    NSString *lrcStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    // 3.转化成歌词数组
    NSArray *lrcArray = [lrcStr componentsSeparatedByString:@"\n"];
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    for (NSString *lrcLineString in lrcArray) {
        
        // 4.过滤不需要的歌词
        if ([lrcLineString hasPrefix:@"[ti:"] ||
            [lrcLineString hasPrefix:@"[ar:"] ||
            [lrcLineString hasPrefix:@"[al:"] ||
            ![lrcLineString hasPrefix:@"["]) {
            continue;
        }
        // 5.将歌词转化成模型
        XNLrcLine *lrcLine = [XNLrcLine lrcLineString:lrcLineString];
        [tmpArray addObject:lrcLine];
    }

    return tmpArray;
}
@end
