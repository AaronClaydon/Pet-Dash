//
//  LevelSelectViewController.m
//  COM4510Pair
//
//  Created by Aaron Claydon on 18/01/2017.
//  Copyright © 2017 aca13ytw. All rights reserved.
//

#import "GameViewController.h"
#import "LevelSelectViewController.h"

@interface LevelSelectViewController ()

@end

@implementation LevelSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadLevelWithModel:(GameModel*)gameModel {
    self.toLoadGameModel = gameModel;
    
    [self performSegueWithIdentifier:@"segueToGame" sender:self];
}

-(IBAction)levelOneClicked:(id)sender {
    [self loadLevelWithModel: [[GameModel alloc] initWithWidth:5 andHeight:6 andStartTime:120]];
}
-(IBAction)levelTwoClicked:(id)sender {
    [self loadLevelWithModel: [[GameModel alloc] initWithWidth:6 andHeight:7 andStartTime:120]];
}
-(IBAction)levelThreeClicked:(id)sender {
    [self loadLevelWithModel: [[GameModel alloc] initWithWidth:7 andHeight:8 andStartTime:120]];
}
-(IBAction)levelFourClicked:(id)sender {
    [self loadLevelWithModel: [[GameModel alloc] initWithWidth:8 andHeight:9 andStartTime:120]];
}
-(IBAction)levelFiveClicked:(id)sender {
    [self loadLevelWithModel: [[GameModel alloc] initWithWidth:9 andHeight:10 andStartTime:120]];
}
-(IBAction)levelSixClicked:(id)sender {
    [self loadLevelWithModel: [[GameModel alloc] initWithWidth:10 andHeight:11 andStartTime:120]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"segueToGame"]) {
        //if we are transfering to score page - set the score
        GameViewController* gameViewController = [segue destinationViewController];
        
        [gameViewController setGameModel:self.toLoadGameModel];
    }
}

@end
