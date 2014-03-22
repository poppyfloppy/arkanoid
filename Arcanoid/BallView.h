//
//  BallView.h
//  Arcanoid
//
//  Created by Валерий Борисов on 02.03.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BallView : UIView {

}

@property (nonatomic) int ballRadius;
@property (nonatomic, strong) UIColor* ballcolor;

-(id) initWithPoint:(CGPoint)originPoint radius: (int)radius andColor: (UIColor*) color;
@end
