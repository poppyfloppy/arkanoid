//
//  MenuViewController.h
//  Arcanoid
//
//  Created by Валерий Борисов on 24.02.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController {
    __weak IBOutlet UIButton *startButton;
    __weak IBOutlet UIButton *highScoreButton;
    __weak IBOutlet UIButton *settingsButton;
}
- (IBAction)startGame:(id)sender;


@end
