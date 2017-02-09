//
//  XNLrcCell.h
//  XNQQMusic
//
//  Created by xunan on 2017/2/4.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XNLrcLabel;
@interface XNLrcCell : UITableViewCell

+ (instancetype)lrcCellWithTableView:(UITableView *)tableView;

/** LrcLabel */
@property (strong, nonatomic) XNLrcLabel *lrcLabel;

@end
