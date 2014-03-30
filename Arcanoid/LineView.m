//
//  LineView.m
//  Arcanoid
//
//  Created by Валерий Борисов on 24.03.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import "LineView.h"

@implementation LineView

-(id)initWithPoints:(CGPoint *)points :(int)count {
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        linePoints = points;
        pointsCount = count;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(ctx, 0.0f, 0.0f, 1.0f, 1.0f);
    CGContextAddLines(ctx, linePoints, pointsCount);
    CGContextStrokePath(ctx);
}

@end
