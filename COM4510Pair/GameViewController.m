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
    
    self.gameModel.gameArray = [@[
                         [@[ @"yellow", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ] mutableCopy],
                        [ @[ @"red", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ]mutableCopy],
                         [@[ @"red", @"red", @"blue", @"yellow", @"orange", @"red", @"red" ]mutableCopy],
                        [ @[ @"yellow", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ]mutableCopy],
                        [ @[ @"red", @"yellow", @"blue", @"yellow", @"orange", @"red", @"red" ]mutableCopy],
                        [ @[ @"red", @"green", @"yellow", @"yellow", @"orange", @"red", @"red" ]mutableCopy],
                        [ @[ @"red", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ]mutableCopy],
                        [ @[ @"red", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ]mutableCopy],
                         ] mutableCopy];
    
    [self updateScore];
    [self drawTiles];
    [self initTimer];
    [self updateTimer];
}

-(void)drawTiles {
    //delete all current tiles
    [[self.gameField subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSDictionary *tiles = @{
                            @"red" : [UIImage imageNamed:@"grid_mouse_smaller.png"],
                            @"green" : [UIImage imageNamed:@"grid_dog_smaller.png"],
                            @"blue" : [UIImage imageNamed:@"grid_bird_smaller.png"],
                            @"yellow" : [UIImage imageNamed:@"grid_cat_smaller.png"],
                            @"orange" : [UIImage imageNamed:@"grid_fish_smaller.png"]
                            };
    
    int tileSize = ([UIScreen mainScreen].bounds.size.width - 10) / self.gameModel.width;
    
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
    
    if (score >= 3) {
        self.gameModel.score += score;
        
        [self updateScore];
        
        self.gameModel.gameArray = self.gameModel.gameArrayNew;
        [self drawTiles];
    }
    
    NSLog(@"button clicked %@ %i %i %i", tileType, row, column, score);
}

-(void)updateScore {
    [self.scoreLabel setText:[NSString stringWithFormat:@"%i", self.gameModel.score]];
}

-(void)updateTimer {
    int seconds = self.gameModel.currentTime % 60;
    int minutes = (self.gameModel.currentTime / 60) % 60;
    [self.timerLabel setText:[NSString stringWithFormat:@"%2d:%02d", minutes, seconds]];
}


-(void)initTimer{
    self.gameModel.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    self.gameModel.currentTime = 10;
}
-(void)timerFired{
    self.gameModel.currentTime--;
    [self updateTimer];
    
    if(self.gameModel.currentTime == 0) {
        [self performSegueWithIdentifier:@"segueToScore" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"segueToScore"]) {
        ScoreViewController* scoreViewController = [segue destinationViewController];
        
        [scoreViewController setScoreResult:self.gameModel.score];
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
