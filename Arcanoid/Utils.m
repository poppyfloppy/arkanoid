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

+(NSString*) readFileByPath: (NSString*) name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"txt"];
    NSString *file = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error: NULL];
    
    return file;
}

@end
