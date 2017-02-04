//
//  XNMusicTool.h
//  XNQQMusic
//
//  Created by xunan on 2017/2/3.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XNMusic;

@interface XNMusicTool : NSObject


/**
 所有的音乐
 */
+ (NSArray *)musics;


/**
 当前正在播放的音乐
 */
+ (XNMusic *)playingMusic;

/**
 设置默认的音乐
 */
+ (void)setupPlayingMusic:(XNMusic *)playingMusic;


/**
 上一首音乐
 */
+ (XNMusic *)previousMusic;

/**
 下一首音乐
 */
+ (XNMusic *)nextMusic;

@end
