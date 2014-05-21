//
//  Collision.h
//  Arcanoid
//
//  Created by Валерий Борисов on 21.03.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Actor.h"

typedef struct {
    BOOL vCol;
    BOOL hCol;
    float distance;
    CGPoint collisionPoint;
} CollisionStruct;

@interface Collision : NSObject {
    Actor* actorModel;
    CGRect actor1;
    CGRect object;
}

-(id) initWithActor: (Actor*) actor: (CGRect) actor1Frame andObject: (CGRect) actor2Frame;

-(CollisionStruct) forecastCollisionBall;
-(void) getLineCoeffs : (CGPoint)p1 : (CGPoint)p2 : (float*) coeffs;
-(CollisionStruct) checkBorderCollisionInRect;
-(CollisionStruct) forecastBorderCollsiion: (CGRect) actor andFrame: (CGRect) frame;

@end
