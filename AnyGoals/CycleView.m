//
//  CycleView.m
//  AnyGoals
//
//  Created by Eric Cao on 3/11/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "CycleView.h"

@implementation CycleView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGRect borderRect = CGRectInset(rect, 1, 1);

// CGRect borderRect = CGRectMake(0.0, 0.0, self.frame.size.width-3, self.frame.size.width-3);
 CGContextRef context = UIGraphicsGetCurrentContext();
 CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
 CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
 CGContextSetLineWidth(context, 2.0);
 CGContextFillEllipseInRect (context, borderRect);
 CGContextStrokeEllipseInRect(context, borderRect);
 CGContextFillPath(context);
}


@end
