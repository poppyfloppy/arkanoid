//
//  Collision.m
//  Arcanoid
//
//  Created by Валерий Борисов on 21.03.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import "Collision.h"

@implementation Collision

-(CollisionStruct)checkCollisionBall: (CGRect)ball withObject: (CGRect)obj {
    CollisionStruct collision;
    [self emptyCollisionStruct : &collision];
    CollisionStruct forecastCollision;
    [self emptyCollisionStruct : &forecastCollision];
    [self forecastCollision:ball :obj : &forecastCollision];
 
    collision.distance = forecastCollision.distance;
    if (collision.distance <= 1.0 && collision.distance >= 0) {
        NSLog(@"distance %f", forecastCollision.distance);
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

-(void) forecastCollision:(CGRect) ball : (CGRect)object : (CollisionStruct*) forecastCollision {
    float distance = -1.0f;
    forecastCollision->distance = distance;
    if ([self isObjectFront:ball : object]) {
        Ball *ballModel = [Ball sharedBall];
        //Прямая для шара по направлениям через его центр
        CGPoint ballCenter = [self getCenterCGRect:ball];
        float dx = ballModel.hDirection * cos(M_PI / 180 * [ballModel angle]) * [ballModel speed];
        float dy = ballModel.vDirection * sin(M_PI / 180 * [ballModel angle]) * [ballModel speed];
        CGPoint ballNextDirectCenter = CGPointMake(ballCenter.x + dx, ballCenter.y + dy);
        //Параметры прямой шара
        float ballLineCoeffs[3];
        [self getLineCoeffs:ballCenter : ballNextDirectCenter: ballLineCoeffs];
        
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
        
        float xtop = [self getXtwoLines:ballLineCoeffs :topLineCoeffs];
        float xcenter = [self getXtwoLines:ballLineCoeffs :centerLineCoeffs];
        float xbottom = [self getXtwoLines:ballLineCoeffs :botLineCoeffs];
//        NSLog(@"xtop = %f, xcenter = %f, xbot = %f", xtop, xcenter, xbottom);
        CGPoint collisonPoint;
        float d;
        if (xtop >= object.origin.x && xtop <= (object.origin.x + object.size.width) && xbottom >= object.origin.x && xbottom <= (object.origin.x + object.size.width)) {
            d = object.size.height / 2;
            collisonPoint = CGPointMake(xcenter + ballModel.hDirection * (-1) * d, object.origin.y + object.size.height / 2 + d * ballModel.vDirection * (-1));
            forecastCollision->vCol = YES;
        } else if (xtop >= object.origin.x && xtop <= (object.origin.x + object.size.width)) {
            d = MIN(xtop - object.origin.x, object.origin.x + object.size.width - xtop);
            collisonPoint = CGPointMake(xtop + ballModel.hDirection * (-1) * d, object.origin.y + d * ballModel.vDirection * (-1));
            forecastCollision->hCol = YES;
        } else if (xbottom >= object.origin.x && xbottom <= (object.origin.x + object.size.width)) {
            d = MIN(xbottom - object.origin.x, object.origin.x + object.size.width - xbottom);
            collisonPoint = CGPointMake(xbottom + ballModel.hDirection * (-1) * d, object.origin.y + object.size.height + d * ballModel.vDirection * (-1));
            forecastCollision->hCol = YES;
        }
        
        CGPoint collisonBallPoint = CGPointMake(ballModel.hDirection * ball.size.width / 2 + ballCenter.x, ballModel.vDirection * ball.size.height / 2 + ballCenter.y);
        distance = sqrtf(fabsf(collisonPoint.x - collisonBallPoint.x) * fabsf(collisonPoint.x - collisonBallPoint.x) + fabsf(collisonPoint.y - collisonBallPoint.y) * fabsf(collisonPoint.y - collisonBallPoint.y));
        forecastCollision->distance = distance;
//        NSLog(@"distance = %f", forecastCollision->distance);
    }
}

-(BOOL) isObjectFront: (CGRect) ball : (CGRect)obj {
    if ([[Ball sharedBall] vDirection] == 1 && ball.origin.y < obj.origin.y) {
        return YES;
    }
    if ([[Ball sharedBall] vDirection] == -1 && ball.origin.y > obj.origin.y) {
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
