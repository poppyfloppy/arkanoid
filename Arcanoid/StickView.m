//
//  StickView.m
//  Arcanoid
//
//  Created by Валерий Борисов on 02.03.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import "StickView.h"

@implementation StickView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect bounds = [self bounds];
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2;
    center.y = bounds.origin.y + bounds.size.height / 2;

    
    CGContextSetLineWidth(ctx, 4.0);
    CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1.0);
//    CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
    CGContextAddRect(ctx, CGRectMake(bounds.origin.x, bounds.origin.y, 60, 10));
    CGContextStrokePath(ctx);
}


@end
