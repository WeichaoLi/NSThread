//
//  LWCViewController.h
//  NSThread
//
//  Created by 李伟超 on 14-11-7.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LWCViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *myTableView;

@end
