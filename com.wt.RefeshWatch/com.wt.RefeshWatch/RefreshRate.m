//
//  RefreshRate.m
//  leakManager
//
//  Created by cdyjy-cdwutao3 on 2016/10/8.
//  Copyright © 2016年 horace. All rights reserved.
//

#import "RefreshRate.h"
#import "AppDelegate.h"
#import "DragLabel.h"

#import <mach/mach.h>

@interface RefreshRate(){
    
}
+(instancetype)single;
@property(assign,nonatomic) NSInteger count;
@property(assign,nonatomic) NSInteger saveCount;
@property(strong,nonatomic) NSTimer * timer;
@property(strong,nonatomic) CADisplayLink* displayLink;

@property(strong,nonatomic) DragLabel * label;
@end

@implementation RefreshRate
+(instancetype)single{
    static RefreshRate* rate;
    if(rate){
        return rate;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rate = [[RefreshRate alloc] init];
    });
    return rate;
}

-(void)startWatch{
    self.count = 0;
    self.saveCount = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkFire)];
    //    self.link.paused = YES;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)stopWatch{
    [self.timer invalidate];
    self.timer = nil;
    
    [self.displayLink invalidate];
}

-(void)displayLinkFire{
    self.count++;
}

-(void)timerFire{
    self.saveCount = self.count;
    self.count = 0;
//    NSLog(@"rate:%@",@(self.saveCount));
//    NSLog(@"displayrate:%@",@(self.displayLink.frameInterval));
    AppDelegate* app = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    
    if(!self.label){
        self.label = [[DragLabel alloc] initWithFrame:CGRectMake(100, 100, 70, 30)];
        [app.window addSubview:self.label];
        self.label.layer.borderWidth = 1;
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.layer.borderColor = [[UIColor blueColor] CGColor];
        self.label.adjustsFontSizeToFitWidth = YES;
        self.label.userInteractionEnabled = YES;
        
    }
    float cpu = [self cpu_usage];
    self.label.text = [NSString stringWithFormat:@"%@|%@",@(self.saveCount),@(cpu)];
    [app.window bringSubviewToFront:self.label];
    
}


-(float) cpu_usage
{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

+ (void)start{
    RefreshRate* rate = [RefreshRate single];
    [rate startWatch];
}

+ (void)stop{
    RefreshRate* rate = [RefreshRate single];
    [rate stopWatch];
}
@end
