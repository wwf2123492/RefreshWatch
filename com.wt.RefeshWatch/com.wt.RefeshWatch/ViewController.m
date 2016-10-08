//
//  ViewController.m
//  com.wt.RefeshWatch
//
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
//    __weak ViewController* weakSelf = self;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        for(int i = 0;i< 100000;i++){
//            for(int j = 0;j< 10000;j++){
//        }
//        }
////        sleep(1);
//        if(isShow){
//            
//                [weakSelf sleepAction];
//        }
//    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (1 && isShow) {
            for(int i = 0;i< 1000000;i++){
                for(int j = 0;j< 10000;j++){
                }
            }

        }
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
