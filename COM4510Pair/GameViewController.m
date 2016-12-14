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
                         @[ @"red", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ],
                         @[ @"red", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ],
                         @[ @"red", @"green", @"blue", @"yellow", @"orange", @"blue", @"blue" ],
                         @[ @"yellow", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ],
                         @[ @"red", @"green", @"blue", @"blue", @"orange", @"red", @"red" ],
                         @[ @"red", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ],
                         @[ @"red", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ],
                         @[ @"red", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ],
                         ] mutableCopy];
    
    NSDictionary *tiles = @{
                                @"red" : [UIImage imageNamed:@"grid_red.png"],
                                @"green" : [UIImage imageNamed:@"grid_green.png"],
                                @"blue" : [UIImage imageNamed:@"grid_bird.png"],
                                @"yellow" : [UIImage imageNamed:@"grid_cat.png"],
                                @"orange" : [UIImage imageNamed:@"grid_fish.png"]
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

-(int)checkClusterMatchForTile:(NSString *)tile inRow:(int)row andColumn:(int)column {
    int score = 0;
    NSMutableArray* toCheckArray = [[NSMutableArray alloc] init];
    
    //Add the first point to the stack of tiles to check
    [self addPointToCheckArray:toCheckArray withRow:row andColumn:column];
    
    while ([toCheckArray count] > 0) {
        //Get and remove the first value from the stack
        NSValue* pointValue = [toCheckArray objectAtIndex:0];
        CGPoint point;
        [pointValue getValue:&point];
        [toCheckArray removeObjectAtIndex:0];
        
        //TODO: CHANGE THIS TO A CUSTOM STRUCT USING INTS NOT FLOATS
        row = point.x;
        column = point.y;
        
        //Incrase the score by one
        score++;
        
        //Check the nearby touching tiles
        if(row - 1 >= 0) {
            if([[self.gameArray objectAtIndex:row - 1] objectAtIndex:column] == tile) {
                [self addPointToCheckArray:toCheckArray withRow:row-1 andColumn:column];
            }
        }
        if(row + 1 < self.height) {
            if([[self.gameArray objectAtIndex:row + 1] objectAtIndex:column] == tile) {
                [self addPointToCheckArray:toCheckArray withRow:row+1 andColumn:column];
            }
        }
        if(column - 1 >= 0) {
            if([[self.gameArray objectAtIndex:row] objectAtIndex:column - 1] == tile) {
                [self addPointToCheckArray:toCheckArray withRow:row andColumn:column-1];
            }
        }
        if(column + 1 < self.width) {
            if([[self.gameArray objectAtIndex:row] objectAtIndex:column + 1] == tile) {
                [self addPointToCheckArray:toCheckArray withRow:row andColumn:column+1];
            }
        }

    }
    
    return score;
}

-(void)addPointToCheckArray:(NSMutableArray*)toCheckArray withRow:(int)row andColumn:(int)column {
    //Only add points that haven't already been checked
    if([[[self.checkedArray objectAtIndex:row] objectAtIndex:column] isEqual: @false]) {
        CGPoint structValue = CGPointMake(row, column);
        NSValue *value = [NSValue valueWithBytes:&structValue objCType:@encode(CGPoint)];
        [toCheckArray addObject:value];
        
        //Set the point as being checked
        NSMutableArray* rowArray = [self.checkedArray objectAtIndex:row];
        [rowArray replaceObjectAtIndex:column withObject:@true];
        [self.checkedArray replaceObjectAtIndex:row withObject:rowArray];
    }
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
