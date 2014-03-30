//
//  Collision.m
//  Arcanoid
//
//  Created by Валерий Борисов on 21.03.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import "Collision.h"

@implementation Collision

-(id)initWithBall:(CGRect)ballFrame andObject:(CGRect)objectFrame {
    self = [self init];
    if (self) {
        ballModel = [Ball sharedBall];
        ball = ballFrame;
        object = objectFrame;
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
    
        CGPoint ballCenter = [self getCenterCGRect:ball];
        int ballDirection[2] = {ballModel.hDirection, ballModel.vDirection};
        
        CGPoint p1Ball = CGPointMake(ballCenter.x + ball.size.width / 2 * ballModel.hDirection, ballCenter.y + ball.size.height / 2 * ballModel.vDirection);
        float ballFirstLineCoeffs[3];
        [self getLineForPoint:p1Ball angle:ballModel.angle vectorDirection:ballDirection outputLine:ballFirstLineCoeffs];
        CGPoint p2Ball = CGPointMake(p1Ball.x + ballModel.hDirection * (-1) * ball.size.width, p1Ball.y);
        float ballSecondLineCoeffs[3];
        [self getLineForPoint:p2Ball angle:ballModel.angle vectorDirection:ballDirection outputLine:ballSecondLineCoeffs];
        
        int vDirection[2] = {0, 1};
        int hDirection[2] = {1, 0};
        CGPoint objectCenter =  [self getCenterCGRect:object];
        
        CGPoint p1Object = CGPointMake(objectCenter.x - object.size.width / 2 * ballModel.hDirection, objectCenter.y);
        CGPoint p2Object = CGPointMake(objectCenter.x, objectCenter.y - object.size.height / 2 * ballModel.vDirection);
        float line1Coeffs[3];
        [self getLineForPoint:p1Object angle:90 vectorDirection:vDirection outputLine:line1Coeffs];

        float line2Coeffs[3];
        [self getLineForPoint:p2Object angle:0 vectorDirection:hDirection outputLine:line2Coeffs];
        
        CGPoint l1Balll1Object = [self getCollisionPoint:ballFirstLineCoeffs :line1Coeffs];
        CGPoint l1Balll2Object = [self getCollisionPoint:ballFirstLineCoeffs :line2Coeffs];
        
        CGPoint l2Balll1Object = [self getCollisionPoint:ballSecondLineCoeffs :line1Coeffs];
        CGPoint l2Balll2Object = [self getCollisionPoint:ballSecondLineCoeffs :line2Coeffs];
        
        if ([self isLineCollision:forecastCollision :l1Balll2Object :l1Balll1Object]) {
            CGPoint collisionPoint = forecastCollision->collisionPoint;
            CGPoint collisonBallPoint = CGPointMake(ballModel.hDirection * ball.size.width / 2 + ballCenter.x, ballModel.vDirection * ball.size.height / 2 + ballCenter.y);
            forecastCollision->distance = sqrtf(fabsf(collisionPoint.x - collisonBallPoint.x) * fabsf(collisionPoint.x - collisonBallPoint.x) + fabsf(collisionPoint.y - collisonBallPoint.y) * fabsf(collisionPoint.y - collisonBallPoint.y));
        } else if ([self isLineCollision: forecastCollision :l2Balll2Object :l2Balll1Object]) {
            CGPoint collisionPoint = forecastCollision->collisionPoint;
            CGPoint collisonBallPoint = CGPointMake(ballModel.hDirection * (-1) * ball.size.width / 2 + ballCenter.x, ballModel.vDirection * ball.size.height / 2 + ballCenter.y);
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
    } else if (vPoint.y >= object.origin.y && vPoint.y <= (object.origin.y + object.size.height)) {
        collision->hCol = YES;
        collision->collisionPoint = vPoint;
        isLineCollision = YES;
    }
    
    return isLineCollision;
}

-(BOOL) isObjectFront {
    if ([ballModel vDirection] == 1 && ball.origin.y < object.origin.y) {
        return YES;
    }
    if ([ballModel vDirection] == -1 && ball.origin.y > object.origin.y) {
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
