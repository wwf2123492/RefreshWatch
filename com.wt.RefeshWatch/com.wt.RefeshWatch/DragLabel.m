//
//  DragLabel.m
//  leakManager
//
//  Created by cdyjy-cdwutao3 on 2016/10/8.
//  Copyright © 2016年 horace. All rights reserved.
//

#import "DragLabel.h"
@interface DragLabel(){
    CGPoint startLocation;
}

@end

@implementation DragLabel

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    // Calculate and store offset, and pop view into front if needed
    CGPoint pt = [[touches anyObject] locationInView:self];
    startLocation = pt;
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    // Calculate offset
    CGPoint pt = [[touches anyObject] locationInView:self];
    float dx = pt.x - startLocation.x;
    float dy = pt.y - startLocation.y;
    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    
    float halfx = CGRectGetMidX(self.bounds);
    newcenter.x = MAX(halfx, newcenter.x);
    newcenter.x = MIN(self.superview.bounds.size.width - halfx, newcenter.x);
    
    float halfy = CGRectGetMidY(self.bounds);
    newcenter.y = MAX(halfy, newcenter.y);
    newcenter.y = MIN(self.superview.bounds.size.height - halfy, newcenter.y);
    
    self.center = newcenter;
}

@end
