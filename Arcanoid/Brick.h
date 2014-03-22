//
//  Brick.h
//  Arcanoid
//
//  Created by Валерий Борисов on 04.03.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Brick : NSObject {
}

@property (nonatomic) float width;
@property (nonatomic) int height;
@property (nonatomic, strong) UIColor* color;
@property (nonatomic) int i;
@property (nonatomic) int j;

-(NSString*) getKey;
+(float) getOptimalWidthWithCol : (int)columsCount;

@end
