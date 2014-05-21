//
//  GameViewController.h
//  Arcanoid
//
//  Created by Валерий Борисов on 27.02.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BallView.h"
#import "StickView.h"
#import "ControlView.h"
#import "InfoView.h"
#import "Collision.h"
#import "LineView.h"
#import "Utils.h"

#define EXPLOSION_NUMBER_PICTURES 48

@interface GameViewController : UIViewController {
    CADisplayLink *displayLink;
    
    BallView *ballView;
    StickView *stickView;
    ControlView *controlView;
    CGPoint defaultBallCenter;
    CGPoint defaultStickCenter;
    UIView *gameFieldView;
    
    UILabel *countdownLabel;
    NSArray *countdownTextArray;
    int currentCountdownText;
    
    NSMutableArray *brickModels;
    NSMutableDictionary *brickViews;
    
    UIView *infoView;
    UILabel *scoreLabel;
    int score;
    
    BOOL isRunning;
    
    UIImageView *explosionView;
    NSMutableArray *explosionPics;

    CGPoint *points;
    LineView *ballLine;
    __weak IBOutlet UIView *mainView;
    __weak IBOutlet UILabel *fpsLabel;
    
    double prevTime;
}

-(void)render;
-(double)delta;

@end
