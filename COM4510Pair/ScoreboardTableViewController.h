//
//  ScoreboardTableViewController.h
//  COM4510Pair
//
//  Created by aca13ytw on 19/01/2017.
//  Copyright © 2017 aca13ytw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HighScoreModel.h"

@interface ScoreboardTableViewController : UITableViewController

-(IBAction)closeButtonTapped:(UIButton *)sender;
@property (strong) HighScoreModel* highScoreModel;

@end
