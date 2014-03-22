//
//  MenuViewController.m
//  Arcanoid
//
//  Created by Валерий Борисов on 24.02.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import "MenuViewController.h"
#import "GameViewController.h"

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    startButton.layer.borderWidth = 1.0f;
    startButton.layer.cornerRadius = 10;
    startButton.layer.borderColor = [[UIColor colorWithRed:23/255.0 green:126/255.0 blue:255/255.0 alpha:1.0] CGColor];
    
    highScoreButton.layer.borderWidth = 1.0f;
    highScoreButton.layer.cornerRadius = 10;
    highScoreButton.layer.borderColor = [[UIColor colorWithRed:23/255.0 green:126/255.0 blue:255/255.0 alpha:1.0] CGColor];
    
    settingsButton.layer.borderWidth = 1.0f;
    settingsButton.layer.cornerRadius = 10;
    settingsButton.layer.borderColor = [[UIColor colorWithRed:23/255.0 green:126/255.0 blue:255/255.0 alpha:1.0] CGColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startGame:(id)sender {
    GameViewController *gvc = [[GameViewController alloc] init];
    [self.navigationController pushViewController:gvc animated:YES];
}


@end
