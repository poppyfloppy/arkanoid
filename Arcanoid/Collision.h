//
//  Collision.h
//  Arcanoid
//
//  Created by Валерий Борисов on 21.03.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ball.h"

typedef struct {
    BOOL vCol;
    BOOL hCol;
    float distance;
    CGPoint collisionPoint;
} CollisionStruct;

@interface Collision : NSObject {
    Ball* ballModel;
    CGRect ball;
    CGRect object;
}

-(id) initWithBall: (CGRect) ballFrame andObject: (CGRect) objectFrame;
//if object's nil, check with walls
-(CollisionStruct) forecastCollisionBall;
-(void) getLineCoeffs : (CGPoint)p1 : (CGPoint)p2 : (float*) coeffs;

@end
