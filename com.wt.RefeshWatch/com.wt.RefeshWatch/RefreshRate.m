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
        self.label = [[DragLabel alloc] initWithFrame:CGRectMake(100, 100, 30, 30)];
        [app.window addSubview:self.label];
        self.label.layer.borderWidth = 1;
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.layer.borderColor = [[UIColor blueColor] CGColor];
        self.label.userInteractionEnabled = YES;
        
    }
    self.label.text = [NSString stringWithFormat:@"%@",@(self.saveCount)];
    [app.window bringSubviewToFront:self.label];
    
}


- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    // Retrieve the touch point
    NSLog(@"log");
//    beginPoint = [[touches anyObject] locationInView:self]; //记录第一个点，以便计算移动距离
//    
//    if ([self._delegate respondsToSelector: @selector(animalViewTouchesBegan)]) //设置代理类，
//        在图像移动的时候，可以做一些处理
//        [self._delegate animalViewTouchesBegan];
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
