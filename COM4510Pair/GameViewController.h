//
//  GameViewController.h
//  COM4510Pair
//
//  Created by aca13ytw on 18/11/2016.
//  Copyright © 2016 aca13ytw. All rights reserved.
//

#import "BackgroundViewController.h"
#import "TileButton.h"

@interface GameViewController : BackgroundViewController

@property (weak) IBOutlet UILabel* scoreLabel;
@property (weak) IBOutlet UILabel* timerLabel;
@property (weak) IBOutlet UIView* gameField;
@property (strong) NSMutableArray* gameArray;
@property int width;
@property int height;


@property (strong) NSMutableArray* checkedArray;

-(void)initGame;
-(void)buttonClicked:(TileButton*)sender;
-(int)checkClusterMatchForTile:(NSString*)tile inRow:(int)row andColumn:(int)column;
@end
