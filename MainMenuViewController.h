//
//  MainMenuViewController.h
//  COM4510Pair
//
//  Created by Aaron Claydon on 04/02/2017.
//  Copyright © 2017 aca13ytw. All rights reserved.
//

#import "BackgroundViewController.h"
#import <GameKit/GameKit.h>

@interface MainMenuViewController : BackgroundViewController

-(IBAction)clickScoreboard:(id)sender;
@property BOOL gameCenterEnabled;

@end
