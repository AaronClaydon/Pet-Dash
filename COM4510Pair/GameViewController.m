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
    self.gameModel = [[GameModel alloc] init];
    
    self.gameModel.width = 7;
    self.gameModel.height = 8;
    int tileSize = ([UIScreen mainScreen].bounds.size.width - 10) / self.gameModel.width;
    
    self.gameModel.gameArray = [@[
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
                                @"red" : [UIImage imageNamed:@"grid_mouse_smaller.png"],
                                @"green" : [UIImage imageNamed:@"grid_dog_smaller.png"],
                                @"blue" : [UIImage imageNamed:@"grid_bird_smaller.png"],
                                @"yellow" : [UIImage imageNamed:@"grid_cat_smaller.png"],
                                @"orange" : [UIImage imageNamed:@"grid_fish_smaller.png"]
                                };
    
    [self updateScore];
    
    for (int row = 0; row < self.gameModel.height; row++) {
        for (int column = 0; column < self.gameModel.width; column++) {
            NSString* tileType = [[self.gameModel.gameArray objectAtIndex:row] objectAtIndex:column];
            
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
    NSString* tileType = [[self.gameModel.gameArray objectAtIndex:row] objectAtIndex:column];
    
    self.gameModel.checkedArray = [@[
                       [@[ @false, @false, @false, @false, @false, @false, @false ] mutableCopy],
                       [@[ @false, @false, @false, @false, @false, @false, @false ] mutableCopy],
                       [@[ @false, @false, @false, @false, @false, @false, @false ] mutableCopy],
                       [@[ @false, @false, @false, @false, @false, @false, @false ] mutableCopy],
                       [@[ @false, @false, @false, @false, @false, @false, @false ] mutableCopy],
                       [@[ @false, @false, @false, @false, @false, @false, @false ] mutableCopy],
                       [@[ @false, @false, @false, @false, @false, @false, @false ] mutableCopy],
                       [@[ @false, @false, @false, @false, @false, @false, @false ] mutableCopy],
                       ] mutableCopy];
    
    int score = [self.gameModel checkClusterMatchForTile:tileType inRow:row andColumn:column];
    self.gameModel.score += score;
    
    [self updateScore];
    
    NSLog(@"button clicked %@ %i %i %i", tileType, row, column, score);
}

-(void)updateScore {
    [self.scoreLabel setText:[NSString stringWithFormat:@"%i", self.gameModel.score]];
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
