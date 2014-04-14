//
//  Ball.m
//  Arcanoid
//
//  Created by Валерий Борисов on 05.03.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import "Ball.h"

@implementation Ball

@synthesize radius;
@synthesize speed;
@synthesize color;

-(id)init {
    self = [super init];
    if (self) {
        [self setRadius:8];
        [self setSettingsSpeed:5];
        [self setSpeed:5];
        [self setAngle:45];
        [self setVDirection:-1];
        [self setHDirection:1];
        [self setColor:[UIColor orangeColor]];
    }
    
    return self;
}

+(Ball *)sharedBall {
    static Ball *ball = nil;
    if (!ball) {
        ball = [[super allocWithZone:nil] init];
    }
    
    return ball;
}

+(id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedBall];
}

@end
