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

-(CollisionStruct)checkCollisionBall {
    CollisionStruct collision;
    [self emptyCollisionStruct : &collision];
    CollisionStruct forecastCollision;
    [self emptyCollisionStruct : &forecastCollision];
    [self forecastCollision: &forecastCollision];
 
    collision.distance = forecastCollision.distance;
    if (forecastCollision.distance > 0)
//        NSLog(@"distance = %f", forecastCollision.distance);
    if (collision.distance <= 3.0 && collision.distance >= 0) {
        if (forecastCollision.hCol)
            collision.hCol = YES;
        if (forecastCollision.vCol)
            collision.vCol = YES;
    }
    
    return collision;
}

-(void)emptyCollisionStruct: (CollisionStruct*) collision {
    collision->distance = 0.0f;
    collision->hCol = NO;
    collision->vCol = NO;
}

-(void) forecastCollision: (CollisionStruct*) forecastCollision {
    if ([self isObjectFront]) {
        //Прямая для шара по направлениям через его центр
        CGPoint ballCenter = [self getCenterCGRect:ball];
        float dx = ballModel.hDirection * cos(M_PI / 180 * [ballModel angle]) * [ballModel speed];
        float dy = ballModel.vDirection * sin(M_PI / 180 * [ballModel angle]) * [ballModel speed];
        CGPoint ballNextDirectCenter = CGPointMake(ballCenter.x + dx, ballCenter.y + dy);
        float ballFirstLineCoeffs[3];
        [self getLineCoeffs:ballCenter : ballNextDirectCenter: ballFirstLineCoeffs];
        
        CGPoint firstPointSeconfLine = CGPointMake(ballCenter.x + ballModel.hDirection * ball.size.width, ballCenter.y);
        CGPoint secondPointSeconfLine = CGPointMake(ballNextDirectCenter.x + ballModel.hDirection * ball.size.width, ballNextDirectCenter.y);
        float ballSecondLineCoeffs[3];
        [self getLineCoeffs:firstPointSeconfLine: secondPointSeconfLine: ballSecondLineCoeffs];
        
        //Прямая для объекта через центр
        CGPoint objectCenter = [self getCenterCGRect:object];
        CGPoint objectSecondPoint = CGPointMake(object.origin.x + object.size.width, object.origin.y + object.size.height / 2);
        float centerLineCoeffs[3];
        [self getLineCoeffs:objectCenter :objectSecondPoint :centerLineCoeffs];
        
        CGPoint topFirstPoint = object.origin;
        CGPoint topSecondPoint = CGPointMake(object.origin.x + object.size.width, object.origin.y);
        float topLineCoeffs[3];
        [self getLineCoeffs:topFirstPoint :topSecondPoint: topLineCoeffs];
        
        CGPoint botFirstPoint = CGPointMake(object.origin.x, object.origin.y + object.size.height);
        CGPoint botSecondPoint = CGPointMake(object.origin.x + object.size.width, object.origin.y + object.size.height);
        float botLineCoeffs[3];
        [self getLineCoeffs:botFirstPoint :botSecondPoint: botLineCoeffs];
        
        float xftop = [self getXtwoLines:ballFirstLineCoeffs :topLineCoeffs];
        float xfbottom = [self getXtwoLines:ballFirstLineCoeffs :botLineCoeffs];
        
        float xstop = [self getXtwoLines:ballSecondLineCoeffs :topLineCoeffs];
        float xsbottom = [self getXtwoLines:ballSecondLineCoeffs :botLineCoeffs];
        
       
        CGPoint collisonBallPoint = CGPointMake(ballModel.hDirection * ball.size.width / 2 + ballCenter.x, ballModel.vDirection * ball.size.height / 2 + ballCenter.y);
        float distance1 = -1.0f, distance2 = -1.0f;
        if([self isLineCollision:forecastCollision :xftop :xfbottom]) {
//            NSLog(@"firstLine colPoint x = %f", collisonBallPoint.x);
            distance1 = sqrtf(fabsf(collisionPoint.x - collisonBallPoint.x) * fabsf(collisionPoint.x - collisonBallPoint.x) + fabsf(collisionPoint.y - collisonBallPoint.y) * fabsf(collisionPoint.y - collisonBallPoint.y));
        }
        if([self isLineCollision: forecastCollision :xstop :xsbottom]) {
           distance2 = sqrtf(fabsf(collisionPoint.x - collisonBallPoint.x) * fabsf(collisionPoint.x - collisonBallPoint.x) + fabsf(collisionPoint.y - collisonBallPoint.y) * fabsf(collisionPoint.y - collisonBallPoint.y));
        }
        if (distance1 > 0 && distance1 < distance2) {
            forecastCollision->distance = distance1;
//            NSLog(@"distance1 = %f", distance1);
        } else if (distance2 > 0 && distance2 < distance1) {
            forecastCollision->distance = distance2;
//            NSLog(@"distance2 = %f", distance2);
        } else
            forecastCollision->distance = -1.0f;
    } else
        forecastCollision->distance = -1.0f;
}

-(BOOL) isLineCollision: (CollisionStruct*) collision : (float) xtop : (float) xbottom {
    BOOL isLineCollision = NO;
    float d = 0;
    if (xtop >= object.origin.x && xtop <= (object.origin.x + object.size.width)) {
        d = MIN(xtop - object.origin.x, object.origin.x + object.size.width - xtop);
        if (ballModel.vDirection == 1) {
            collision->vCol = YES;
            collisionPoint = CGPointMake(xtop, object.origin.y);
        } else {
            collisionPoint = CGPointMake(xtop + ballModel.hDirection * (-1) * d, object.origin.y + d * ballModel.vDirection * (-1));
            collision->hCol = YES;
        }
        isLineCollision = YES;
    } else if (xbottom >= object.origin.x && xbottom <= (object.origin.x + object.size.width)) {
        d = MIN(xbottom - object.origin.x, object.origin.x + object.size.width - xbottom);
        if (ballModel.vDirection == -1) {
            collision->vCol = YES;
            collisionPoint = CGPointMake(xbottom, object.origin.y + object.size.height);
        } else {
            collisionPoint = CGPointMake(xbottom + ballModel.hDirection * (-1) * d, object.origin.y + object.size.height + d * ballModel.vDirection * (-1));
            collision->hCol = YES;
        }
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

-(float) getXtwoLines : (float*) line1 : (float*) line2 {
    float x = (line1[1] * line2[2] - line1[2] * line2[1]) / (line1[0] * line2[1] - line2[0] * line1[1]);
    
    return x;
}

@end
