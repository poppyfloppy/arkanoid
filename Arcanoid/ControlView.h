//
//  ControlView.h
//  Arcanoid
//
//  Created by Валерий Борисов on 03.03.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControlView : UIView {
    CGPoint touch;
}

-(CGPoint)getTouch;
-(void)setTouch:(CGPoint)point;

@end
