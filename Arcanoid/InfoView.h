//
//  InfoView.h
//  Arcanoid
//
//  Created by Валерий Борисов on 18.03.14.
//  Copyright (c) 2014 Валерий Борисов. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoView : UIView {
    
}

-(void) pauseButtonClickedForTarget: (id)target andSelector : (SEL) selector;
-(void) backButtonClickedForTarget: (id)target andSelector : (SEL) selector;
-(void) setInfoText : (NSString*) string;

@property (nonatomic, weak) UIButton* pauseButton;
@property (nonatomic, strong, readonly) UIButton* backButton;
@property (nonatomic, weak) UILabel* infoText;


@end
