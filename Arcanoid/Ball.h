//
//  Ball.h
//  Arcanoid
//
//  Created by Валерий Борисов on 05.03.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Actor.h"

@interface Ball : Actor {
}

@property (nonatomic) int radius;
@property (nonatomic) float speed;
@property (nonatomic) float settingsSpeed;
@property (nonatomic) UIColor *color;

+(Ball*) sharedBall;

@end
