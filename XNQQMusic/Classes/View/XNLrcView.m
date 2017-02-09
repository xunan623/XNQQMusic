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

@end
