//
//  Brick.m
//  Arcanoid
//
//  Created by Валерий Борисов on 28.02.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import "BrickView.h"

@implementation BrickView

@synthesize brickColor;

-(id)initWithPoint:(CGPoint)point andSize:(CGSize)size andColor:(UIColor *)color {
    self = [self initWithFrame:CGRectMake(point.x, point.y, size.width, size.height)];
    if (self) {
        [self setBrickColor:color];
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
    
    CGContextSetFillColorWithColor(ctx, [brickColor CGColor]);
    CGContextAddRect(ctx, CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height));
    CGContextFillPath(ctx);
    
    CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1);
    CGContextSetLineWidth(ctx, 2);
    CGContextAddRect(ctx, CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height));
    CGContextStrokePath(ctx);
}


@end
