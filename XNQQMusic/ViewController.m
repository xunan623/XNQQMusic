//
//  ViewController.m
//  XNQQMusic
//
//  Created by xunan on 2017/1/17.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<CALayerDelegate>

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, strong) UIImageView *secondImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}






- (void)setupCoreAnimation {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    // View放图片
    UIImage *image = [UIImage imageNamed:@"jj_icon@2x.png"];
    view.layer.contents = (__bridge id)image.CGImage;
    
    // 比例拉伸适应图层的边界
    view.layer.contentsGravity = kCAGravityResizeAspect;
    
    // 屏幕比例 1 或者 2
    view.layer.contentsScale = [UIScreen mainScreen].scale;
    
    // 显示layer的具体位置
    //    view.layer.contentsRect = CGRectMake(-0.5,-0.5, 0.5, 0.5);
    
    view.layer.contentsCenter = CGRectMake(0.25, 0.25, 0.5, 0.5);
    
    
    // View放颜色
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(0, 0, 100, 100);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    blueLayer.delegate = self;
    blueLayer.contentsScale = [UIScreen mainScreen].scale;
    [view.layer addSublayer:blueLayer];
    [blueLayer display];
    
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 200, 100, 10)];
    imageView.image = [UIImage imageNamed:@"a.png"];
    [self.view addSubview:imageView];
    imageView.layer.anchorPoint = CGPointMake(0.0, 0.9);
    self.secondImageView = imageView;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkTime) userInfo:nil repeats:YES];
    [self checkTime];
}

- (void)checkTime {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitSecond | NSCalendarUnitMinute;
    
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    CGFloat secsAngle = (nowCmps.second) / 60.0 * M_PI * 2.0;
    
    self.secondImageView.transform = CGAffineTransformMakeRotation(secsAngle);
    
}

#pragma mark - CALayerDelegate

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    CGContextSetLineWidth(ctx, 10.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}

















@end
