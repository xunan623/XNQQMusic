//
//  XNPlayingController.m
//  XNQQMusic
//
//  Created by xunan on 2017/2/3.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNPlayingController.h"
#import "XNMusic.h"
#import "XNMusicTool.h"
#import "XMGAudioTool.h"
#import <Masonry.h>
#import "NSString+XNTimerExtextion.h"
#import "CALayer+PauseAimate.h"

#define XNColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface XNPlayingController ()
/** 歌手背景图片 */
@property (weak, nonatomic) IBOutlet UIImageView *albumView;

/** 进度条 */
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimelabel;

/** 进度条定时器 */
@property (strong, nonatomic) NSTimer *progressTimer;

@property (strong, nonatomic) AVAudioPlayer *currentPlayer;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;

@end

@implementation XNPlayingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.填充毛玻璃效果
    [self setupBlur];
    
    // 2.改变滑块的图片
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    
    // 3.播放音乐
    [self startPlayingMusic];

}

- (void)startPlayingMusic {
    
    // 1.获取当前正在播放的音乐
    XNMusic *playingMusic = [XNMusicTool playingMusic];
    
    // 2.设置界面信息
    self.albumView.image = [UIImage imageNamed:playingMusic.icon];
    self.iconView.image = [UIImage imageNamed:playingMusic.icon];
    self.songLabel.text = playingMusic.name;
    self.singerLabel.text = playingMusic.singer;

    // 3.播放音乐
    AVAudioPlayer *currentPlayer = [XMGAudioTool playMusicWithFileName:playingMusic.filename];
    self.currentPlayer = currentPlayer;
    self.currentTimeLabel.text = [NSString stringWithTime:currentPlayer.currentTime];
    self.totalTimelabel.text = [NSString stringWithTime:currentPlayer.duration];
    // 3.1设置播放按钮
    self.playOrPauseBtn.selected = self.currentPlayer.isPlaying;
    
    // 4.开启定时器
    [self removeProgressTimer];
    [self addProgressTimer];
    
    // 5.添加iconView动画
    [self addIconViewAnimate];
}

- (void)addIconViewAnimate {
    CABasicAnimation *rotateAnimate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimate.fromValue = @0;
    rotateAnimate.toValue = @(M_PI * 2);
    rotateAnimate.repeatCount =  NSIntegerMax;
    rotateAnimate.duration = 20;
    [self.iconView.layer addAnimation:rotateAnimate forKey:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // 图片圆角
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = self.iconView.bounds.size.width / 2 ;
    self.iconView.layer.borderColor = XNColor(36, 36, 36, 1).CGColor;
    self.iconView.layer.borderWidth = 5;
}

- (void)setupBlur {
    
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    [self.albumView addSubview:toolBar]; 
    toolBar.barStyle = UIBarStyleBlack;
    
    toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.albumView);
    }];
}

#pragma mark - 对时间的处理

- (void)addProgressTimer {
    [self updateProgressInfo];
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

- (void)removeProgressTimer {
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (void)updateProgressInfo {
    // 1.更新播放时间
    self.currentTimeLabel.text = [NSString stringWithTime:self.currentPlayer.currentTime];
    
    // 2.更新滑动条
    self.progressSlider.value = self.currentPlayer.currentTime / self.currentPlayer.duration;
}

#pragma mark - 进度条事件处理
- (IBAction)start {
    // 移除定时器
    [self removeProgressTimer];
    
}
- (IBAction)end:(UISlider *)sender {
    
    // 1.更新播放时间
    self.currentPlayer.currentTime = self.progressSlider.value * self.currentPlayer.duration;
    
    // 添加定时器
    [self addProgressTimer];
}
- (IBAction)progressValueChange {
    
    self.currentTimeLabel.text = [NSString stringWithTime:self.progressSlider.value * self.currentPlayer.duration];
}

- (IBAction)touchSider:(UITapGestureRecognizer *)sender {
    
    // 1.获取点击的位置
    CGPoint point = [sender locationInView:sender.view];
    
    // 2.获取点击的比例
    CGFloat ratio = point.x / self.progressSlider.bounds.size.width;

    // 3.更新播放时间
    self.currentPlayer.currentTime = self.currentPlayer.duration * ratio;

    // 4.更新时间和滑块
    [self updateProgressInfo];
}
- (IBAction)playOrPause:(UIButton *)sender {
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.selected;
    
    if (self.currentPlayer.isPlaying) {
        // 1.暂停播放
        [self.currentPlayer pause];
        // 2.移除定时器
        [self removeProgressTimer];
        // 3.暂停旋转动画
        [self.iconView.layer pauseAnimate];
    } else {
        // 3.开始播放
        [self.currentPlayer play];
        // 4.开启定时器
        [self addProgressTimer];
        // 5.开始旋转动画
        [self.iconView.layer resumeAnimate];
    }
}

- (IBAction)previousClick:(UIButton *)sender {
}
- (IBAction)nextClick:(UIButton *)sender {
    // 1.获取当前播放的音乐并停止
    XNMusic *currentMusic = [XNMusicTool playingMusic];
    [XMGAudioTool stopMusicWithFileName:currentMusic.filename];
    
    // 2.获取下一首歌
    XNMusic *nextMusic = [XNMusicTool nextMusic];
    
    // 3.设置下一首歌为默认播放歌曲
    
}

@end
