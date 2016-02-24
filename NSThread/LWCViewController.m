//
//  LWCViewController.m
//  NSThread
//
//  Created by 李伟超 on 14-11-7.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import "LWCViewController.h"
#import <pthread/pthread.h>
#import <libkern/OSAtomic.h>

#define HOST @"http://img2.moko.cc/users/14/4228/1268402/post/"

@interface LWCViewController () {
    NSMutableArray *array;
//    NSLock *lock;
//    NSConditionLock *lock;
//    NSRecursiveLock *lock;
    NSCondition *condition;
    
    OSSpinLock spinLock;
    
    NSThread *thread1;
}

@end


@implementation LWCViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/////////////////////////////////////

int i = 0;

//- (void)testThread {
//    for (int k = 0; k < 100; k++) {
////        @synchronized(self){
//        [lock lock];
//            if (i < 100) {
//                [NSThread sleepForTimeInterval:1];
//                i++;
//                NSLog(@"%i当前线程名称：%@",i,[[NSThread currentThread] name]);
//            }else {
//                [NSThread exit];
//            }
//        [lock unlock];
////        }
//    }
//}

//递归锁
//- (void)testThread {
//    NSRecursiveLock *recursivelock = [[NSRecursiveLock alloc] init];
//    for (int k = 0; k < 100; k++) {
//        [recursivelock lock];
//            if (i < 100) {
//                [NSThread sleepForTimeInterval:1];
//                i++;
//                NSLog(@"%i当前线程名称：%@",i,[[NSThread currentThread] name]);
//            }else {
//                [NSThread exit];
//            }
//        [recursivelock unlock];
//    }
//}

////条件锁
//- (void)testThread1 {
//    for (int k = 0; k < 100; k++) {
//        [lock lockWhenCondition:0];
//        i++;
//        NSLog(@"加=======%d",i);
//        [lock unlockWithCondition:1];
//    }
//}
//
//- (void)testThread2 {
//    for (int k = 0; k < 100; k++) {
//        
//        [lock lockWhenCondition:1];
//        if (i > 0) {
//            i--;
//            NSLog(@"减=======%d",i);
//        }
//        [lock unlockWithCondition:0];
//    }
//}

- (void)createConsumenr
{
    for (int k = 0; k < 100; k++) {
        [condition lock];
        while (i == 0) {
            NSLog(@"=======等待");
            [condition wait];
        }
        i--;
        NSLog(@"减, %d", i);
        [condition unlock];
    }
}

- (void)createProducter
{
    for (int k = 0; k < 100; k++) {
        [condition lock];
        i += 2;
        NSLog(@"加, %d", i);
        [condition signal];
        [condition unlock];
    }
}

pthread_mutex_t mutex;

//- (void)testThread {
//    for (int k = 0; k < 100; k++) {
//        pthread_mutex_lock(&mutex);
//            if (i < 100) {
////                [NSThread sleepForTimeInterval:0.5];
//                i++;
//                NSLog(@"%i当前线程名称：%@",i,[[NSThread currentThread] name]);
//            }else {
//                [NSThread exit];
//                pthread_mutex_destroy(&mutex);
//            }
//        pthread_mutex_unlock(&mutex);
//    }
//}

- (void)testThread {
    for (int k = 0; k < 100; k++) {
        if([[NSThread currentThread] isCancelled]) {
            [NSThread exit];
        }else {
            OSSpinLockLock(&spinLock);
            if (i < 100) {
//                [NSThread sleepForTimeInterval:1];
                i++;
                NSLog(@"当前线程：%@", [NSThread currentThread]);
//                NSLog(@"%i当前线程名称：%@",i,[[NSThread currentThread] name]);
            }else {
                [NSThread exit];
            }
            OSSpinLockUnlock(&spinLock);
        }
    }
}


- (void)startThread{
    thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(testThread)object:nil];
    [thread1 setName:@"线程1"];
    [thread1 start];
    
    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(testThread)object:nil];
    [thread2 setName:@"线程2"];
    [thread2 start];
    
    NSThread *thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(testThread)object:nil];
    [thread3 setName:@"线程3"];
    [thread3 start];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (![thread1 isCancelled]) {
        [thread1 cancel];
    }else {

    }
}


/////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"111" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"f" otherButtonTitles:@"yes", nil];
    [actionsheet showInView:self.view];
    /**
     *  线程安全
     */
    pthread_mutex_init(&mutex, NULL);
    spinLock = OS_SPINLOCK_INIT;
    [self startThread];
    
    array = [NSMutableArray arrayWithObjects:@"40/img2_cover_9718626.jpg", @"6a/img2_src_9717514.jpg", @"3d/img2_src_9717515.jpg", @"2d/img2_src_9717518.jpg", @"d5/img2_src_9717517.jpg", @"f0/img2_src_9717516.jpg", @"f6/img2_cover_9645660.jpg",@"29/img2_src_9672505.jpg", @"d8/img2_src_9672506.jpg", @"d8/img2_src_9642133.jpg", @"d5/img2_src_9642134.jpg", @"6a/img2_src_9642135.jpg", @"da/img2_src_9642136.jpg", @"f0/img2_src_9583716.jpg", @"b6/img2_src_9583717.jpg", @"ee/img2_src_9583718.jpg", @"48/img2_src_9583719.jpg", @"b0/img2_src_9583720.jpg", nil];
}



- (void)loadView {
    [super loadView];
    
//    _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    _myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    _myTableView.delegate = self;
//    _myTableView.dataSource = self;
//    
//    [self.view addSubview:_myTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (NSData *)requestData:(NSIndexPath *)indexPath {
    NSURL *url = [[NSURL alloc] initWithString:[HOST stringByAppendingString:array[indexPath.row]]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return data;
}

- (void)loadImage:(NSIndexPath *)indexPath {
    
    NSData *data = [self requestData:indexPath];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:data,@"data", indexPath, @"indexPath", nil];
    //在主线程更新UI
    [self performSelectorOnMainThread:@selector(updateCellImage:) withObject:dic waitUntilDone:YES];
}

- (void)updateCellImage:(id)Info {
    
    NSDictionary *dic = (NSDictionary *)Info;
    
    NSIndexPath *indexPath = [dic objectForKey:@"indexPath"];
    NSLog(@"更新 %@", indexPath);
    
    UITableViewCell *cell = [_myTableView cellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageWithData:[dic objectForKey:@"data"]];
    
    /*
     *固定ImageView的大小
     */
//    CGSize itemSize = CGSizeMake(100, 100);
//    
//    UIGraphicsBeginImageContext(itemSize);
//    
//    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//    
//    [cell.imageView.image drawInRect:imageRect];
//    
//    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    [_myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *IdentifierCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentifierCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IdentifierCell];
    }
    cell.textLabel.text = @"1";
    
#warning 存在问题， tableviewCell重用，图片没有换掉
    if (cell.imageView.image == nil) {
        //
        [NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self withObject:indexPath];
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
