//
//  CountdownView.h
//  Arcanoid
//
//  Created by Валерий Борисов on 26.05.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountdownView : UILabel {
    int current;
    SEL selector;
    id _target;
}


@property (retain, nonatomic) NSArray *countdownTextArray;

-(void) countdownStartWithTarget: (id) target andSelector: (SEL) finishSelector;
-(id) initWithTextArray: (NSArray*) textArray;

@end
