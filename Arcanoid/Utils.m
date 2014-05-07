//
//  Utils.m
//  Arcanoid
//
//  Created by Валерий Борисов on 06.05.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(double)getTime {
    NSDate *now = [NSDate date];
    
    return [now timeIntervalSince1970];
}

@end
