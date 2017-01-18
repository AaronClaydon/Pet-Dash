//
//  ScoreViewController.h
//  COM4510Pair
//
//  Created by aca13ytw on 12/01/2017.
//  Copyright © 2017 aca13ytw. All rights reserved.
//

#import "BackgroundViewController.h"
#import "Social/Social.h"
#import "GameModel.h"


@interface ScoreViewController : BackgroundViewController

@property (weak) IBOutlet UIButton *Tweet;
@property (weak) IBOutlet UIButton *FBPost;

-(IBAction)TweetPressed;
-(IBAction)FBPressed;
  
@property (weak)IBOutlet UILabel* scoreResultLabel;
@property (weak)IBOutlet UILabel* totalTimeLabel;

@property GameModel* gameModel;

-(void)displayScoreResult;
-(void)displaytotalTime;

@end
