//
//  ViewController.m
//  com.wt.RefeshWatch
//
//  Created by cdyjy-cdwutao3 on 2016/10/8.
//  Copyright © 2016年 cdyjy-cdwutao3. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    BOOL isShow;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"slow view controller");
    isShow = YES;
    [self sleepAction];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    isShow = NO;
}
-(void)sleepAction{
    __weak ViewController* weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        sleep(1);
        if(isShow){
            
                [weakSelf sleepAction];
        }
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
