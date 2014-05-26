//
//  CountdownView.m
//  Arcanoid
//
//  Created by Валерий Борисов on 26.05.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import "CountdownView.h"

@implementation CountdownView

@synthesize countdownTextArray;

-(id) initWithTextArray:(NSArray *)textArray {
    self = [super init];
    if (self) {
        countdownTextArray = textArray;
        [self setTextColor:[UIColor whiteColor]];
        [self setTranslatesAutoresizingMaskIntoConstraints: NO];
        [self setFont:[UIFont boldSystemFontOfSize:40.0f]];
    }
    
    return self;
}

-(void)countdownStartWithTarget:(id)target andSelector:(SEL)finishSelector {
    selector = finishSelector;
    _target = target;
    [self setText:[countdownTextArray objectAtIndex:current]];
    current++;
    [self countdownAnimation];
}

-(void) countdownAnimation {
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [scaleAnimation setToValue:[NSNumber numberWithFloat:2]];
    [scaleAnimation setDuration:1.0f];
    [scaleAnimation setDelegate:self];
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeAnimation setToValue:[NSNumber numberWithFloat:0.0f]];
    [fadeAnimation setDuration:1.0f];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    [group setAnimations:[NSArray arrayWithObjects:fadeAnimation, scaleAnimation, nil]];
    [group setDuration:1.0f];
    [[self layer] addAnimation:scaleAnimation forKey:@"countdownAnimation"];
    [group setDelegate:self];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag && current < [countdownTextArray count]) {
        [self setText:[countdownTextArray objectAtIndex:current]];
        current++;
        [self countdownAnimation];
    } else if (flag && current == [countdownTextArray count]) {
        [_target performSelector: selector];
    }
}

@end
