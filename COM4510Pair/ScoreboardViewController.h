//
//  ScoreboardViewController.h
//  COM4510Pair
//
//  Created by aca13ytw on 17/01/2017.
//  Copyright © 2017 aca13ytw. All rights reserved.
//

#import "BackgroundViewController.h"

@interface ScoreboardViewController : BackgroundViewController

@property (weak)IBOutlet UILabel* highScoreLabel;

@property int highScore;

-(void)displayHighScore;

@end
