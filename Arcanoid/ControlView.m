//
//  ControlView.m
//  Arcanoid
//
//  Created by Валерий Борисов on 03.03.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import "ControlView.h"

@implementation ControlView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        touch = CGPointMake(frame.size.width / 2, 0);
    }
    return self;
}

-(CGPoint)getTouch {
    return touch;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {
        if ([ t tapCount] < 2) {
            touch = [t locationInView:self];
        }
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {
        if ([ t tapCount] < 2) {
            if ([t locationInView:self].y > 0)
                touch = [t locationInView:self];
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
