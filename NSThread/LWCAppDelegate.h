//
//  LWCAppDelegate.h
//  NSThread
//
//  Created by 李伟超 on 14-11-7.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LWCViewController;

@interface LWCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *NavCon;
@property (strong, nonatomic) LWCViewController *viewController;

@end
