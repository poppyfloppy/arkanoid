//
//  DeltaTime.h
//  Arcanoid
//
//  Created by Валерий Борисов on 05.05.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeltaTime : NSObject {
    double lastFrame;
}

+(double) sharedDeltaTime;

@end
