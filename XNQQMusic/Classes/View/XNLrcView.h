//
//  XNLrcView.h
//  XNQQMusic
//
//  Created by xunan on 2017/2/4.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XNLrcLabel;
@interface XNLrcView : UIScrollView

@property (copy, nonatomic) NSString *lrcName;

/** 当前播放到的时间 */
@property (nonatomic, assign) NSTimeInterval currentTime;

/** 主界面歌词label */
@property (strong, nonatomic) XNLrcLabel *lrcLabel;

@end
