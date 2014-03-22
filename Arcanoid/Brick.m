//
//  Brick.m
//  Arcanoid
//
//  Created by Валерий Борисов on 04.03.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import "Brick.h"

@implementation Brick

@synthesize height;
@synthesize width;
@synthesize color;

-(NSString *)getKey {
    return [NSString stringWithFormat:@"%i%i", [self i], [self j]];
}

+(float)getOptimalWidthWithCol:(int)columsCount {
    float width = 0;
    float deviceWidth = [UIScreen mainScreen].bounds.size.width;
    deviceWidth -= (columsCount + 1) * 3;
    width = deviceWidth / columsCount;
    
    return width;
}

@end
