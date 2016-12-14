//
//  GameViewController.m
//  COM4510Pair
//
//  Created by aca13ytw on 18/11/2016.
//  Copyright © 2016 aca13ytw. All rights reserved.
//

#import "GameViewController.h"
#import "TileButton.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initGame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initGame {
    self.width = 7;
    self.height = 8;
    int tileSize = ([UIScreen mainScreen].bounds.size.width - 10) / self.width;
    
    self.gameArray = [@[
                         @[ @"yellow", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ],
                         @[ @"red", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ],
                         @[ @"red", @"red", @"blue", @"yellow", @"orange", @"red", @"red" ],
                         @[ @"yellow", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ],
                         @[ @"red", @"yellow", @"blue", @"yellow", @"orange", @"red", @"red" ],
                         @[ @"red", @"green", @"yellow", @"yellow", @"orange", @"red", @"red" ],
                         @[ @"red", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ],
                         @[ @"red", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ],
                         ] mutableCopy];
    
    NSDictionary *tiles = @{
                                @"red" : [UIImage imageNamed:@"grid_red.png"],
                                @"green" : [UIImage imageNamed:@"grid_green.png"],
                                @"blue" : [UIImage imageNamed:@"grid_bird_smaller.png"],
                                @"yellow" : [UIImage imageNamed:@"grid_cat_smaller.png"],
                                @"orange" : [UIImage imageNamed:@"grid_fish_smaller.png"]
                                };
    
    for (int row = 0; row < self.height; row++) {
        for (int column = 0; column < self.width; column++) {
            NSString* tileType = [[self.gameArray objectAtIndex:row] objectAtIndex:column];
            
            TileButton *button = [TileButton buttonWithType:UIButtonTypeCustom];
            [button setRow:row];
            [button setColumn:column];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:@"" forState:UIControlStateNormal];
            [button setBackgroundImage: [tiles objectForKey: tileType] forState:UIControlStateNormal];
            button.frame = CGRectMake(column * tileSize, row * tileSize, tileSize, tileSize);
            [self.gameField addSubview:button];
        }
    }
}

-(void)buttonClicked:(TileButton*)sender {
    int row = sender.row;
    int column = sender.column;
    NSString* tileType = [[self.gameArray objectAtIndex:row] objectAtIndex:column];
    
    self.checkedArray = [@[
                       [@[ @false, @false, @false, @false, @false, @false, @false ] mutableCopy],
                       [@[ @false, @false, @false, @false, @false, @false, @false ] mutableCopy],
                       [@[ @false, @false, @false, @false, @false, @false, @false ] mutableCopy],
                       [@[ @false, @false, @false, @false, @false, @false, @false ] mutableCopy],
                       [@[ @false, @false, @false, @false, @false, @false, @false ] mutableCopy],
                       [@[ @false, @false, @false, @false, @false, @false, @false ] mutableCopy],
                       [@[ @false, @false, @false, @false, @false, @false, @false ] mutableCopy],
                       [@[ @false, @false, @false, @false, @false, @false, @false ] mutableCopy],
                       ] mutableCopy];
    
    int score = [self checkClusterMatchForTile:tileType inRow:row andColumn:column];
    
    NSLog(@"button clicked %@ %i %i %i", tileType, row, column, score);
}

-(int)checkClusterMatchForTile:(NSString*)tile inRow:(int)row andColumn:(int)column {
    int score = 0;
    
    NSLog(@"row %i column %i", row, column);
    
    if([[[self.checkedArray objectAtIndex:row] objectAtIndex:column] isEqual: @false]) {
        //[[self.checkedArray objectAtIndex:row] replaceObjectAtIndex:column withObject:@true];
        NSMutableArray* rowArray = [self.checkedArray objectAtIndex:row];
        [rowArray replaceObjectAtIndex:column withObject:@true];
        [self.checkedArray replaceObjectAtIndex:row withObject:rowArray];
        
        if(row - 1 >= 0) {
            if([[self.gameArray objectAtIndex:row - 1] objectAtIndex:column] == tile) {
                NSLog(@"row -1 match");
                score++;
                
                score += [self checkClusterMatchForTile:tile inRow:row-1 andColumn:column];
            }
        }
        if(row + 1 < self.height) {
            if([[self.gameArray objectAtIndex:row + 1] objectAtIndex:column] == tile) {
                NSLog(@"row +1 match");
                score++;
                
                score += [self checkClusterMatchForTile:tile inRow:row+1 andColumn:column];
            }
        }
        if(column - 1 >= 0) {
            if([[self.gameArray objectAtIndex:row] objectAtIndex:column - 1] == tile) {
                NSLog(@"column -1 match");
                score++;
                
                score += [self checkClusterMatchForTile:tile inRow:row andColumn:column-1];
            }
        }
        if(column + 1 < self.width) {
            if([[self.gameArray objectAtIndex:row] objectAtIndex:column + 1] == tile) {
                NSLog(@"column +1 match");
                score++;
                
                score += [self checkClusterMatchForTile:tile inRow:row andColumn:column+1];
            }
        }
    }
    NSLog(@"score %i", score);
    return score;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
