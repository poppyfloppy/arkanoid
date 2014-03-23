//
//  GameViewController.m
//  Arcanoid
//
//  Created by Валерий Борисов on 27.02.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//
#import "GameViewController.h"
#import "BrickView.h"
#import "Brick.h"
#import "Ball.h"
#import "Collision.h"

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        brickViews = [[NSMutableDictionary alloc] init];
        brickModels = [NSMutableArray new];
        
        explosionPics = [[NSMutableArray alloc] init];
        explosionPics = [NSMutableArray new];
        
        countdownTextArray = [NSArray arrayWithObjects:@"3", @"2", @"1", @"GO!", nil];
        for (int i = 1; i <= EXPLOSION_NUMBER_PICTURES; i++) {
            [explosionPics addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Explosion_%i", i]]];
        }
        isRunning = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"star_bg.jpg"]]];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 0.1 * screenRect.size.height)];
    gameFieldView = [[UIView alloc] initWithFrame:CGRectMake(0, infoView.bounds.size.height, screenRect.size.width, screenRect.size.height * 0.8)];
    controlView = [[ControlView alloc] initWithFrame:CGRectMake(0, infoView.bounds.size.height + gameFieldView.bounds.size.height, screenRect.size.width, screenRect.size.height * 0.1)];
    
    explosionView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self initInfoView];
    [self initExplosionView];
    
    stickView = [[StickView alloc] initWithFrame:CGRectMake(screenRect.size.width / 2 - 30, gameFieldView.bounds.origin.y + gameFieldView.bounds.size.height - 15, 60, 10)];
    [stickView setBackgroundColor:[UIColor whiteColor]];
    
    Ball *ball  = [Ball sharedBall];
    ballView = [[BallView alloc] initWithPoint:CGPointMake(screenRect.size.width / 2 - [ball radius], stickView.frame.origin.y - 2 * [ball radius]) radius:[ball radius] andColor:[ball color]];
    
    [self createBrickModels];
    [self createBrickViews];
    
    [self.view addSubview:gameFieldView];
    [self.view addSubview:controlView];
    [self.view addSubview:infoView];
    
    [gameFieldView addSubview:ballView];
    [gameFieldView addSubview:stickView];
    [gameFieldView addSubview:explosionView];
    for (NSString *key in brickViews) {
        BrickView *brickView = [brickViews objectForKey:key];
        [gameFieldView addSubview:brickView];
    }
    
    [self addCountdown];
    
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

-(NSString*) scoreString {
    return [NSString stringWithFormat:@"Счет: %i", score];
}

-(void) initInfoView {
    [infoView setBackgroundColor:[UIColor blackColor]];
    scoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self updateScore];
    [scoreLabel setTextColor:[UIColor whiteColor]];
    [scoreLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scoreLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    
    [infoView addSubview:scoreLabel];
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:scoreLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:infoView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:scoreLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:infoView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    [infoView addConstraints:@[centerXConstraint, centerYConstraint]];

}

-(void) initExplosionView {
    [explosionView setAnimationImages: explosionPics];
    [explosionView setAnimationDuration:1.5];
    [explosionView setAnimationRepeatCount:1];
}

-(void) updateScore {
    [scoreLabel setText:[self scoreString]];
}
                      
-(void) addCountdown {
    countdownLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [countdownLabel setTextColor:[UIColor whiteColor]];
    [countdownLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [countdownLabel setText:[countdownTextArray objectAtIndex:currentCountdownText]];
    [countdownLabel setFont:[UIFont boldSystemFontOfSize:40.0f]];
    [self.view addSubview:countdownLabel];
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:countdownLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:countdownLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    [self.view addConstraints:@[centerXConstraint, centerYConstraint]];
    
    currentCountdownText++;
    [self countdownAnimation];
}

-(void) countdownAnimation {
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [scaleAnimation setToValue:[NSNumber numberWithFloat:2]];
    [scaleAnimation setDuration:1.0f];
    [scaleAnimation setDelegate:self];
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeAnimation setToValue:[NSNumber numberWithFloat:0.0f]];
    [fadeAnimation setDuration:1.0f];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    [group setAnimations:[NSArray arrayWithObjects:fadeAnimation, scaleAnimation, nil]];
    [group setDuration:1.0f];
    [[countdownLabel layer] addAnimation:scaleAnimation forKey:@"countdownAnimation"];
    [group setDelegate:self];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag && currentCountdownText < [countdownTextArray count]) {
        [countdownLabel setText:[countdownTextArray objectAtIndex:currentCountdownText]];
        currentCountdownText++;
        [self countdownAnimation];
    } else if (flag && currentCountdownText == [countdownTextArray count]) {
        [countdownLabel setHidden:YES];
        [self startGame];
    }
    ;
}

-(void) createBrickModels {
    int i = 8;
    int j = 7;
    for (int col = 0; col < i; col++) {
        for (int row = 0; row < j; row++) {
            Brick *brick = [[Brick alloc] init];
            [brick setI:col];
            [brick setJ:row];
            [brick setHeight:15];
            [brick setWidth:[Brick getOptimalWidthWithCol:i]];
            if (row % 2 == 0) {
                [brick setColor:[UIColor orangeColor]];
            } else {
                [brick setColor:[UIColor whiteColor]];
            }
            
            [brickModels addObject:brick];
        }
    }
}

-(void) createBrickViews {
    for (int i = 0; i < [brickModels count]; i++) {
        Brick *brick = [brickModels objectAtIndex:i];
        CGPoint point = CGPointMake(brick.i * brick.width + 3 * (brick.i + 1), brick.j * brick.height + 3 * (brick.j + 1));
        BrickView *brickView = [[BrickView alloc] initWithPoint:point andSize:CGSizeMake(brick.width, brick.height) andColor:[brick color]];
        
        [brickViews setObject:brickView forKey:[brick getKey]];
    }
}

-(void) startGame {
    isRunning = YES;
}

/*
Игровой цикл
*/
-(void)render {
    if (isRunning) {
        [self ballMoving];
        [self checkBricksCollision];
        [self checkStickCollision];
        [self checkBorderCollision];
        [self stickControl];
    }
}

-(void) ballAnimation {

}

-(void) ballMoving {
    Ball *ball = [Ball sharedBall];
    float dx = ball.hDirection * cos(M_PI / 180 * [ball angle]) * [ball speed];
    float dy = ball.vDirection * sin(M_PI / 180 * [ball angle]) * [ball speed];
//    NSLog(@"dx = %f  dy = %f", dx, dy);
//    NSLog(@"h direct %i", ball.hDirection);
    [ballView setCenter:CGPointMake(ballView.center.x + dx, ballView.center.y + dy)];
    [ballView setNeedsDisplay];
}

-(void) stickControl {
    CGPoint touchPoint = [controlView getTouch];
    if (touchPoint.x > (stickView.bounds.size.width / 2) && touchPoint.x < ([[UIScreen mainScreen] bounds].size.width - stickView.bounds.size.width / 2)) {
        [stickView setCenter:CGPointMake(touchPoint.x, stickView.center.y)];
        [stickView setNeedsDisplay];
    } else if (touchPoint.x < (stickView.bounds.size.width / 2)) {
        [stickView setCenter:CGPointMake(stickView.bounds.size.width / 2, stickView.center.y)];
    } else {
        [stickView setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width - stickView.bounds.size.width / 2, stickView.center.y)];
    }
}

-(void) checkStickCollision {
    Ball *ball = [Ball sharedBall];
    Collision *collision = [[Collision alloc] initWithBall:ballView.frame andObject:stickView.frame];
    CollisionStruct c = [collision checkCollisionBall];
    if (c.hCol)
        [ball setHDirection:[ball hDirection] * -1];
    if (c.vCol)
        [ball setVDirection:[ball vDirection] * -1];
    [self optimazeCurrentSpeed:c.distance];
}
        
-(void) optimazeCurrentSpeed : (float) distance {
    Ball *ball = [Ball sharedBall];
    if (distance > 0 && distance < ball.settingsSpeed) {
        [ball setSpeed: distance];
        NSLog(@"optimaze speed = %f", distance);
    } else
        [ball setSpeed:[ball settingsSpeed]];
}

-(void) checkBorderCollision {
    Ball *ball = [Ball sharedBall];
    if ([self isWallCollision])
        [ball setHDirection:[ball hDirection] * -1];
    if ([self isRoofCollision]) {
        [ball setVDirection:[ball vDirection] * -1];
    }
    if ([self isFloorCollision]) {
        isRunning = NO;
    }
}

/*
Участок кода где проверяются коллизии
*/

-(BOOL) isWallCollision {
    CGPoint ballCenter = ballView.center;
    if (gameFieldView.frame.size.width - ballCenter.x - ballView.frame.size.width / 2 < 1 && [[Ball sharedBall] hDirection] == 1) {
        NSLog(@"wall collision");
        return YES;
    }
    else if (ballCenter.x - ballView.frame.size.width / 2 < 1 && [[Ball sharedBall] hDirection] == -1) {
        NSLog(@"wall collision");
        return YES;
    } else
        return NO;
}

-(BOOL) isRoofCollision {
    if (ballView.center.y - ballView.frame.size.height / 2 < 1 && [[Ball sharedBall] vDirection] == -1) {
        return YES;
    }
    return NO;
}

-(BOOL) isFloorCollision {
    if (gameFieldView.frame.size.height - ballView.center.y - ballView.frame.size.height / 2 < 1 && [[Ball sharedBall] vDirection] == 1) {
        return YES;
    }
    return NO;
}

//-(void) checkBrickCollision {
//    for (NSString *key in [brickViews allKeys]) {
//        BrickView *brickView = [brickViews objectForKey:key];
//        if ([self collision:[brickView frame]]) {
//            [brickView removeFromSuperview];
//            [brickViews removeObjectForKey:key];
//            score += 10 * [[Ball sharedBall] speed];
//            [explosionView setCenter:[brickView center]];
//            [explosionView startAnimating];
//            [self updateScore];
//        }
//    }
//}

/*
Проверка на коллицизии, заодно меняет у экземпляра объекта Ball коэффиценты направления
На вход подается CGRect (с ним производится проверка коллизий ballView)
*/

-(void) checkBricksCollision {
    Ball *ball = [Ball sharedBall];
    float distance = -1;
    BOOL isVcollision = NO;
    BOOL isHcollision = NO;
    for (NSString *key in [brickViews allKeys]) {
        BrickView *brickView = [brickViews objectForKey:key];
        Collision *collision = [[Collision alloc] initWithBall:ballView.frame andObject:brickView.frame];
        CollisionStruct c = [collision checkCollisionBall];
        if (c.hCol) {
            NSLog(@"horizontal");
            isHcollision = YES;
            [self brickCollision:key];
        }
        if (c.vCol) {
            NSLog(@"vertical distance %f", c.distance);
            isVcollision = YES;
            [self brickCollision:key];
        }
        if (distance < 0 || (distance > c.distance && c.distance > 0)) {
            distance = c.distance;
        }
    }
    if (isHcollision)
        [ball setHDirection:[ball hDirection] * -1];
    if (isVcollision)
        [ball setVDirection:[ball vDirection] * -1];
    if (distance > 0)
        NSLog(@"distance = %f", distance);
    [self optimazeCurrentSpeed:distance];
}
    
-(void) brickCollision : (NSString*) key {
    BrickView *brickView = [brickViews objectForKey:key];
    [brickView removeFromSuperview];
    [brickViews removeObjectForKey:key];
    score += 10 * [[Ball sharedBall] speed];
    [explosionView setCenter:[brickView center]];
    [explosionView startAnimating];
    [self updateScore];
}

//-(BOOL)collision : (CGRect) object {
//    Ball *ball = [Ball sharedBall];
//    BOOL isVCollision = NO;
//    BOOL isHCollision = NO;
//    CGPoint ballCenter = [ballView center];
//    CGPoint brickCenter = CGPointMake(object.origin.x + object.size.width / 2, object.origin.y + object.size.height / 2);
//    if (sqrt(pow(fabs(brickCenter.x - brickCenter.x), 2) + pow(fabs(brickCenter.y - brickCenter.y), 2)) <=
//        sqrt(pow(ballView.bounds.size.height / 2, 2) + pow(ballView.bounds.size.width / 2, 2)) + sqrt(pow(object.size.height / 2, 2) + pow(object.size.width / 2, 2))) {
//        float h = object.size.height / 5;
//        float w = h;
//        int n = object.size.width / w;
//        int m = object.size.height / h;
//        
//        for (int i = 0; i < m; i++) {
//            for (int j = 0; j < n; j++) {
//                float originX = object.origin.x + j * w;
//                float originY = object.origin.y + i * h;
//                CGPoint center = CGPointMake(originX + w / 2, originY + h / 2);
//                float distance =  sqrtf(fabsf(ballCenter.x - center.x) * fabsf(ballCenter.x - center.x) + fabsf(ballCenter.y - center.y) * fabsf(ballCenter.y - center.y));
//                if (distance  <=  (w / 2 + ballView.frame.size.height) / 2) {
//                    if (i == (m - 1) || i == 0) {
//                        NSLog(@"v j = %i, i = %i", j, i);
//                        isVCollision = YES;
//                    } else {
//                        NSLog(@"h j = %i, i = %i", j, i);
//                        isHCollision = YES;
//                    }
//                    break;
//                }
//            }
//        }
//    }
//    if (isHCollision)
//        [ball setHDirection:[ball hDirection] * -1];
//    if (isVCollision) {
////        [ball setHDirection:[ball hDirection] * -1];
//        [ball setVDirection:[ball vDirection] * -1];
//    }
//    if (isVCollision || isHCollision)
//        return  YES;
//    
//    return NO;
//
//}

@end
