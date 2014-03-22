//
//  Brick.h
//  Arcanoid
//
//  Created by Валерий Борисов on 28.02.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrickView : UIView {
}

@property UIColor *brickColor;

-(id)initWithPoint: (CGPoint)point andSize: (CGSize)size andColor: (UIColor*)color;

@end
