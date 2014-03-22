//
//  Ball.h
//  Arcanoid
//
//  Created by Валерий Борисов on 05.03.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ball : NSObject {
}

@property (nonatomic) int radius;
@property (nonatomic) float speed;
@property (nonatomic) float settingsSpeed;
@property (nonatomic) int angle;
@property (nonatomic) UIColor *color;
@property (nonatomic) int vDirection;
@property (nonatomic) int hDirection;

+(Ball*) sharedBall;

@end
