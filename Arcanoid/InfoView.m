//
//  InfoView.m
//  Arcanoid
//
//  Created by Валерий Борисов on 18.03.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import "InfoView.h"

@implementation InfoView

@synthesize backButton;
@synthesize infoText;
@synthesize pauseButton;

- (id)initWithFrame:(CGRect)frame {
    CGRect deviceScreen = [[UIScreen mainScreen] bounds];
    frame = CGRectMake(0, 0, deviceScreen.size.width, deviceScreen.size.height * 0.1);
    self = [super initWithFrame:frame];
    if (self) {
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [backButton setTitle:@"text" forState:UIControlStateNormal];
        [self addSubview:backButton];
    }
    return self;
}


- (void)drawRect:(CGRect)rect{
    
}


@end
