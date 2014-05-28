//
//  LevelBuilder.m
//  Arcanoid
//
//  Created by Валерий Борисов on 28.05.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import "LevelBuilder.h"

@implementation LevelBuilder

+(NSMutableArray *)generateBrickModelsFile:(NSString *)file {
    NSMutableArray *brickModels = [[NSMutableArray alloc] init];
    NSArray *rows = [file componentsSeparatedByString:@"\n"];
    for (int i = 0; i < [rows count]; i++) {
        NSLog([rows objectAtIndex:i]);
        NSArray *col = [[rows objectAtIndex:i] componentsSeparatedByString:@" "];
        for (int j = 0; j < [col count]; j++) {
            if ([[col objectAtIndex:j] intValue] > 0) {
                Brick *brick = [[Brick alloc] init];
                [brick setI:i];
                [brick setJ:j];
                [brick setHeight:15];
                [brick setWidth:[Brick getOptimalWidthWithCol:[col count]]];
                if (i % 2 == 0) {
                    [brick setColor:[UIColor orangeColor]];
                } else {
                    [brick setColor:[UIColor whiteColor]];
                }
            
                [brickModels addObject:brick];
            }
        }
    }
    
    return brickModels;
}

@end
