//
//  AppDelegate.m
//  XNQQMusic
//
//  Created by xunan on 2017/1/17.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 1.获取音频会话
    AVAudioSession *session = [AVAudioSession sharedInstance];
    // 2.设置为后台类型
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    // 3.激活会话
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"进入后台");
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"iconViewAnimate"];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"将要进入前台");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"开始活跃");
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"iconViewAnimate"]) return;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"XNIconViewNotification" object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
