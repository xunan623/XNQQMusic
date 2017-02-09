//
//  XNLrcCell.m
//  XNQQMusic
//
//  Created by xunan on 2017/2/4.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNLrcCell.h"

@implementation XNLrcCell

+ (instancetype)lrcCellWithTableView:(UITableView *)tableView {
    static NSString *cellName = @"cellName";
    XNLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[XNLrcCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return self;
}

@end
