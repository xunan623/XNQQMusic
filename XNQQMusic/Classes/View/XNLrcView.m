//
//  XNLrcView.m
//  XNQQMusic
//
//  Created by xunan on 2017/2/4.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNLrcView.h"
#import "XNLrcCell.h"
#import "XNLrcTool.h"
#import <Masonry.h>
#import "XNLrcLabel.h"
#import "XNLrcLine.h"
#import "XNMusic.h"
#import "XNMusicTool.h"
#import <MediaPlayer/MediaPlayer.h>


@interface XNLrcView() <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
/** 歌词数组 */
@property (strong, nonatomic) NSArray *lrcList;

/** 当前刷新的某行 */
@property (assign, nonatomic) NSInteger currentIndex;

@end

@implementation XNLrcView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupTableView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupTableView];
    }
    return self;
}

- (void)setupTableView {
    
    // 1.初始化tableView
    UITableView *tableView = [[UITableView alloc] init];
    [self addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 2.添加约束
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(self.mas_height);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left).offset(self.bounds.size.width);
        make.width.equalTo(self.mas_width);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 40;
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.bounds.size.height * 0.5, 0, self.tableView.bounds.size.height * 0.5, 0);
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lrcList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XNLrcCell *cell = [XNLrcCell lrcCellWithTableView:tableView];
    XNLrcLine *lineModel = self.lrcList[indexPath.row];

    cell.lrcLabel.textColor = [UIColor lightGrayColor];
    cell.lrcLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.lrcLabel.progress = 0.0;
    if (self.currentIndex == indexPath.row) {
        cell.lrcLabel.font = [UIFont systemFontOfSize:17.0f];
        cell.lrcLabel.textColor = [UIColor whiteColor];
    }
    
    cell.lrcLabel.text = lineModel.text;
    return cell;
}

#pragma mark - 重写lrcName

- (void)setLrcName:(NSString *)lrcName {
    _lrcName = lrcName;
    
    // 第一句歌词滚动到中间
    [self.tableView setContentOffset:CGPointMake(0, -self.tableView.bounds.size.height/ 2) animated:YES];
    
    // 让上一首index为0
    self.currentIndex = 0;

    // 1.拆成数组
    self.lrcList = [XNLrcTool setupLrcWithString:lrcName];
    
    // 1.1设置第一句歌词
    XNLrcLine *firstLrcLine = self.lrcList[0];
    self.lrcLabel.text = firstLrcLine.text;
    
    // 2.刷新数据
    [self.tableView reloadData];
}


- (void)setCurrentTime:(NSTimeInterval)currentTime {
    
    
    _currentTime = currentTime;
    
    
    NSInteger count = self.lrcList.count;
    for (NSInteger i = 0; i < count; i++) {
        XNLrcLine *currentLine = self.lrcList[i];
        
        XNLrcLine *nextLine = nil;
        if (i  < self.lrcList.count - 1) {
            nextLine = self.lrcList[i + 1];
        }
        
        // 判断时间
        if ( self.currentIndex !=i && currentTime >= currentLine.time && currentTime < nextLine.time) {
            
            NSIndexPath *previouseIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            
            self.currentIndex = i;
            
            // 滚动表
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            // 刷新上一个cell 和 刷新当前cell
            [self.tableView reloadRowsAtIndexPaths:@[previouseIndexPath, indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            // 设置主界面歌词label
            self.lrcLabel.text = currentLine.text;
            
            // 生成锁屏图片
            [self genaratorLockImage];
        }
        
        if (self.currentIndex == i) { // 当前歌词
            
            // 百分百
            CGFloat value = (currentTime - currentLine.time) / (nextLine.time - currentLine.time);
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            XNLrcCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            cell.lrcLabel.progress = value;
            
            // 设置主界面歌词进度
            self.lrcLabel.progress = value;
            
        }
        
        
    }


}

#pragma mark - 生成锁屏图片

- (void)genaratorLockImage {
    
    // 1.获取当前音乐的图片
    XNMusic *playingMusic = [XNMusicTool playingMusic];
    UIImage *currentImage = [UIImage imageNamed:playingMusic.icon];
    
    // 2.取出歌词
    // 2.1取出当前歌词
    XNLrcLine *currentLrcLine = self.lrcList[self.currentIndex];
    
    // 2.2取出上一句歌词
    NSInteger previouseIndex = self.currentIndex - 1;
    XNLrcLine *previouseLrcLine = nil;
    if (previouseIndex >= 0) {
        previouseLrcLine = self.lrcList[previouseIndex];
    }
    
    // 2.3取出下一句歌词
    NSInteger nextIndex = self.currentIndex + 1;
    XNLrcLine *nextLrcLine = nil;
    if (nextIndex < self.lrcList.count) {
        nextLrcLine = self.lrcList[nextIndex];
    }
    
    // 3.生成水印图片
    UIGraphicsBeginImageContext(currentImage.size);
    
    // 图片画上去
    [currentImage drawInRect:CGRectMake(0, 0, currentImage.size.width, currentImage.size.height)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes1 = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                                  NSParagraphStyleAttributeName : paragraphStyle,
                                  NSForegroundColorAttributeName : [UIColor lightGrayColor]};
    NSDictionary *attributes2 = @{NSFontAttributeName : [UIFont systemFontOfSize:16.0f],
                                  NSParagraphStyleAttributeName : paragraphStyle,
                                  NSForegroundColorAttributeName : [UIColor whiteColor]};

    // 将文字放上去
    CGFloat titleH = 25;
    [previouseLrcLine.text drawInRect:CGRectMake(0, currentImage.size.height - 3 * titleH, currentImage.size.width, titleH) withAttributes:attributes1];
    [currentLrcLine.text drawInRect:CGRectMake(0, currentImage.size.height - 2 * titleH, currentImage.size.width, titleH) withAttributes:attributes2];
    [nextLrcLine.text drawInRect:CGRectMake(0, currentImage.size.height - titleH, currentImage.size.width, titleH) withAttributes:attributes1];
    
    // 3.4获取画好的图片
    UIImage *lockImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 3.5关闭上下文
    UIGraphicsEndImageContext();
    
    // 3.6设置锁屏界面的图片
    [self setupLockScreenInfoWithLockImage:lockImage];


}

#pragma mark - 设置锁屏信息
- (void)setupLockScreenInfoWithLockImage:(UIImage *)lockImage {
    
    /**
     // MPMediaItemPropertyAlbumTitle               // 歌曲名
     // MPMediaItemPropertyAlbumTrackCount
     // MPMediaItemPropertyAlbumTrackNumber
     // MPMediaItemPropertyArtist                   // 歌手名
     // MPMediaItemPropertyArtwork                  // 歌曲图片
     // MPMediaItemPropertyComposer
     // MPMediaItemPropertyDiscCount
     // MPMediaItemPropertyDiscNumber
     // MPMediaItemPropertyGenre
     // MPMediaItemPropertyPersistentID
     // MPMediaItemPropertyPlaybackDuration         // 设置歌曲的总时长
     // MPMediaItemPropertyTitle
     */
    
    XNMusic *currentMusic = [XNMusicTool playingMusic];
    

    // 1.获取锁屏中心
    MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    
    MPMediaItemArtwork *artWorkIcon = [[MPMediaItemArtwork alloc] initWithImage:lockImage];
    
    NSMutableDictionary *nowPlayInfoDict = [NSMutableDictionary dictionary];
    [nowPlayInfoDict setObject:currentMusic.name forKey:MPMediaItemPropertyAlbumTitle];
    [nowPlayInfoDict setObject:currentMusic.singer forKey:MPMediaItemPropertyArtist];
    [nowPlayInfoDict setObject:artWorkIcon forKey:MPMediaItemPropertyArtwork];
    [nowPlayInfoDict setObject:@(self.duration) forKey:MPMediaItemPropertyPlaybackDuration];
    
    [nowPlayInfoDict setObject:@(self.currentTime) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];

    // 2.设置锁屏参数
    playingInfoCenter.nowPlayingInfo = nowPlayInfoDict;
    
    // 3.开启远程交互
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
}


@end
