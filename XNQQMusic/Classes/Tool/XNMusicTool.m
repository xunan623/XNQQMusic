//
//  XNMusicTool.m
//  XNQQMusic
//
//  Created by xunan on 2017/2/3.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNMusicTool.h"
#import "XNMusic.h"
#import <MJExtension.h>

@implementation XNMusicTool

static NSArray *_musics;
static XNMusic *_playingMusic;

+ (void)initialize {
    if (!_musics) _musics = [XNMusic mj_objectArrayWithFilename:@"Musics.plist"];
    if (!_playingMusic) _playingMusic = _musics[1];
}

+ (NSArray *)musics {
    return _musics;
}

+ (XNMusic *)playingMusic {
    return _playingMusic;
}

+ (void)setupPlayingMusic:(XNMusic *)playingMusic {
    _playingMusic = playingMusic;
}

@end
