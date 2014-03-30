//
//  LineView.h
//  Arcanoid
//
//  Created by Валерий Борисов on 24.03.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineView : UIView {
    CGPoint *linePoints;
    int pointsCount;
}

-(id) initWithPoints: (CGPoint*) points : (int) count;

@end
