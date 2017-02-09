//
//  XNLrcLine.h
//  XNQQMusic
//
//  Created by xunan on 2017/2/6.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNLrcLine : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSTimeInterval time;

- (instancetype)initWithLrcLineString:(NSString *)lrcLineString;

+ (instancetype)lrcLineString:(NSString *)lrcLineString;;

@end
