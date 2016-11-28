//
//  GameViewController.m
//  COM4510Pair
//
//  Created by aca13ytw on 18/11/2016.
//  Copyright © 2016 aca13ytw. All rights reserved.
//

#import "GameViewController.h"

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
    int width = 7;
    int height = 8;
    int tileSize = ([UIScreen mainScreen].bounds.size.width - 10) / 7;
    
    self.gameArray = @[
                         @[ @"red", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ],
                         @[ @"red", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ],
                         @[ @"red", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ],
                         @[ @"red", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ],
                         @[ @"red", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ],
                         @[ @"red", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ],
                         @[ @"red", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ],
                         @[ @"red", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ],
                         ];
    
    NSDictionary *tiles = @{
                                @"red" : [UIImage imageNamed:@"grid_red.png"],
                                @"green" : [UIImage imageNamed:@"grid_green.png"],
                                @"blue" : [UIImage imageNamed:@"grid_bird.png"],
                                @"yellow" : [UIImage imageNamed:@"grid_cat.png"],
                                @"orange" : [UIImage imageNamed:@"grid_fish.png"]
                                };
    
    for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
            NSString* tileType = [[self.gameArray objectAtIndex:y] objectAtIndex:x];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:@"" forState:UIControlStateNormal];
            [button setBackgroundImage: [tiles objectForKey: tileType] forState:UIControlStateNormal];
            button.frame = CGRectMake(x * tileSize, y * tileSize, tileSize, tileSize);
            [self.gameField addSubview:button];
        }
    }
}

-(void)buttonClicked {
    
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
