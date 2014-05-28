//
//  LevelBuilder.h
//  Arcanoid
//
//  Created by Валерий Борисов on 28.05.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Brick.h"

@interface LevelBuilder : NSObject {
}

+(NSMutableArray*) generateBrickModelsFile: (NSString*) file;

@end
