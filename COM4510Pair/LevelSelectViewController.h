//
//  LevelSelectViewController.h
//  COM4510Pair
//
//  Created by Aaron Claydon on 18/01/2017.
//  Copyright © 2017 aca13ytw. All rights reserved.
//

#import "BackgroundViewController.h"
#import "GameModel.h"

@interface LevelSelectViewController : BackgroundViewController

@property GameModel* toLoadGameModel;

-(IBAction)levelOneClicked:(id)sender;
-(IBAction)levelTwoClicked:(id)sender;
-(IBAction)levelThreeClicked:(id)sender;
-(IBAction)levelFourClicked:(id)sender;
-(IBAction)levelFiveClicked:(id)sender;
-(IBAction)levelSixClicked:(id)sender;

@end
