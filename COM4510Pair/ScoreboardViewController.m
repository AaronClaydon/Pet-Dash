//
//  ScoreboardViewController.m
//  COM4510Pair
//
//  Created by aca13ytw on 17/01/2017.
//  Copyright © 2017 aca13ytw. All rights reserved.
//

#import "ScoreboardViewController.h"
#import "GameModel.h"

@interface ScoreboardViewController ()

@end

@implementation ScoreboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayHighScore];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)displayHighScore {
    [self.highScoreLabel setText:[NSString stringWithFormat:@"%i", self.highScore]];
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
