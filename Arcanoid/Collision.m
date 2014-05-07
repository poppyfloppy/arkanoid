//
//  Collision.m
//  Arcanoid
//
//  Created by Валерий Борисов on 21.03.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import "Collision.h"

@implementation Collision

-(id)initWithActor:(Actor *)actor :(CGRect)actor1Frame andObject:(CGRect)actor2Frame {
    self = [self init];
    if (self) {
        actorModel = actor;
        actor1 = actor1Frame;
        object = actor2Frame;
    }
    
    return self;
}

-(CollisionStruct) forecastCollisionBall {
    CollisionStruct forecastCollision;
    [self emptyCollisionStruct : &forecastCollision];
    [self forecastCollision: &forecastCollision];
    
    return forecastCollision;
}

-(void)emptyCollisionStruct: (CollisionStruct*) collision {
    collision->distance = 0.0f;
    collision->hCol = NO;
    collision->vCol = NO;
}

-(void) forecastCollision: (CollisionStruct*) forecastCollision {
    if ([self isObjectFront]) {
    
        CGPoint actor1Center = [self getCenterCGRect:actor1];
        int actor1Direction[2] = {actorModel.hDirection, actorModel.vDirection};
        
        CGPoint p1Actor1 = CGPointMake(actor1Center.x + actor1.size.width / 2 * actorModel.hDirection, actor1Center.y + actor1.size.height / 2 * actorModel.vDirection);
        float actor1FirstLineCoeffs[3];
        [self getLineForPoint:p1Actor1 angle:actorModel.angle vectorDirection:actor1Direction outputLine:actor1FirstLineCoeffs];
        
        CGPoint p2Actor1 = CGPointMake(p1Actor1.x + actorModel.hDirection * (-1) * (actor1.size.width), p1Actor1.y);
        float actor1SecondLineCoeffs[3];
        [self getLineForPoint:p2Actor1 angle:actorModel.angle vectorDirection:actor1Direction outputLine:actor1SecondLineCoeffs];
        
        int vDirection[2] = {0, 1};
        int hDirection[2] = {1, 0};
        CGPoint objectCenter =  [self getCenterCGRect:object];
        
        CGPoint p1Object = CGPointMake(objectCenter.x - object.size.width / 2 * actorModel.hDirection, objectCenter.y);
        CGPoint p2Object = CGPointMake(objectCenter.x, objectCenter.y - object.size.height / 2 * actorModel.vDirection);
        float line1Coeffs[3];
        [self getLineForPoint:p1Object angle:90 vectorDirection:vDirection outputLine:line1Coeffs];

        float line2Coeffs[3];
        [self getLineForPoint:p2Object angle:0 vectorDirection:hDirection outputLine:line2Coeffs];
        
        CGPoint l1Balll1Object = [self getCollisionPoint:actor1FirstLineCoeffs :line1Coeffs];
        CGPoint l1Balll2Object = [self getCollisionPoint:actor1FirstLineCoeffs :line2Coeffs];
        
        CGPoint l2Balll1Object = [self getCollisionPoint:actor1SecondLineCoeffs :line1Coeffs];
        CGPoint l2Balll2Object = [self getCollisionPoint:actor1SecondLineCoeffs :line2Coeffs];
        
        if ([self isLineCollision:forecastCollision :l1Balll2Object :l1Balll1Object]) {
            CGPoint collisionPoint = forecastCollision->collisionPoint;
            CGPoint collisonBallPoint = CGPointMake(actorModel.hDirection * actor1.size.width / 2 + actor1Center.x, actorModel.vDirection * actor1.size.height / 2 + actor1Center.y);
            forecastCollision->distance = sqrtf(fabsf(collisionPoint.x - collisonBallPoint.x) * fabsf(collisionPoint.x - collisonBallPoint.x) + fabsf(collisionPoint.y - collisonBallPoint.y) * fabsf(collisionPoint.y - collisonBallPoint.y));
        } else if ([self isLineCollision: forecastCollision :l2Balll2Object :l2Balll1Object]) {
            CGPoint collisionPoint = forecastCollision->collisionPoint;
            CGPoint collisonBallPoint = CGPointMake(actorModel.hDirection * (-1) * actor1.size.width / 2 + actor1Center.x, actorModel.vDirection * actor1.size.height / 2 + actor1Center.y);
            forecastCollision->distance = sqrtf(fabsf(collisionPoint.x - collisonBallPoint.x) * fabsf(collisionPoint.x - collisonBallPoint.x) + fabsf(collisionPoint.y - collisonBallPoint.y) * fabsf(collisionPoint.y - collisonBallPoint.y));
        } else
            forecastCollision->distance = -1.0f;
    } else
        forecastCollision->distance = -1.0f;
}

-(BOOL) isLineCollision: (CollisionStruct*) collision : (CGPoint) hPoint : (CGPoint) vPoint {
    BOOL isLineCollision = NO;
    if (hPoint.x >= object.origin.x && hPoint.x <= (object.origin.x + object.size.width)) {
        collision->vCol = YES;
        collision->collisionPoint = hPoint;
        isLineCollision = YES;
    }
    if (vPoint.y >= object.origin.y && vPoint.y <= (object.origin.y + object.size.height)) {
        collision->hCol = YES;
        collision->collisionPoint = vPoint;
        isLineCollision = YES;
    }
    
    return isLineCollision;
}

-(BOOL) isObjectFront {
    if ([actorModel vDirection] == 1 && actor1.origin.y < object.origin.y) {
        return YES;
    }
    if ([actorModel vDirection] == -1 && actor1.origin.y > object.origin.y) {
        return YES;
    }
    
    return NO;
}

-(CGPoint) getCenterCGRect : (CGRect) rect {
    CGPoint center = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
    
    return center;
}

-(void) getLineCoeffs : (CGPoint)p1 : (CGPoint)p2 : (float*) coeffs {
    coeffs[0] = p1.y - p2.y;
    coeffs[1] = p2.x - p1.x;
    coeffs[2] = p1.x * p2.y - p2.x * p1.y;
}

-(CGPoint) getCollisionPoint: (float*) line1 : (float*) line2 {
    float x = (line1[1] * line2[2] - line1[2] * line2[1]) / (line1[0] * line2[1] - line2[0] * line1[1]);
    float y = (line1[2] * line2[0] - line1[0] * line2[2]) / (line1[0] * line2[1] - line2[0] * line1[1]);
    
    return CGPointMake(x, y);
}

-(void) getLineForPoint: (CGPoint) p1 angle: (float)angle  vectorDirection: (int*) vectorDirection outputLine: (float*) line {
    float dx = vectorDirection[0] * cos(M_PI / 180 * angle) * 10;
    float dy = vectorDirection[1] * sin(M_PI / 180 * angle) * 10;
    CGPoint p2 = CGPointMake(p1.x + dx, p1.y + dy);
    [self getLineCoeffs:p1 :p2 :line];
}


@end
