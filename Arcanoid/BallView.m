//
//  BallView.m
//  Arcanoid
//
//  Created by Валерий Борисов on 02.03.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import "BallView.h"

@implementation BallView

@synthesize ballcolor, ballRadius;

-(id)initWithPoint:(CGPoint)originPoint radius:(int)radius andColor:(UIColor *)color {
    self = [self initWithFrame:CGRectMake(originPoint.x, originPoint.y, 2 * radius, 2 * radius)];
    if (self) {
        ballcolor = color;
        ballRadius = radius;
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
    
    CGRect bounds = [self bounds];
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2;
    center.y = bounds.origin.y + bounds.size.height / 2;

    CGContextSetFillColorWithColor(ctx, [ballcolor CGColor]);
    CGContextFillEllipseInRect(ctx, CGRectMake(bounds.origin.x, bounds.origin.y, ballRadius * 2, ballRadius * 2));
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1.0);
    CGContextAddArc(ctx, center.x, center.y, ballRadius - 1, 0.0, 2 * M_PI, YES);
    CGContextStrokePath(ctx);
}


@end
