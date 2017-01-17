//
//  GameViewController.m
//  COM4510Pair
//
//  Created by aca13ytw on 18/11/2016.
//  Copyright © 2016 aca13ytw. All rights reserved.
//

#import "GameViewController.h"
#import "TileButton.h"
#import "AppDelegate.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set reference to this game view controller in the app delegate
    //so we can pause the game timer on app entering background
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.gameViewController = self;
    
    //tile types and their associated image
    self.tileImages = @{
                        @"red" : [UIImage imageNamed:@"grid_mouse_smaller.png"],
                        @"green" : [UIImage imageNamed:@"grid_dog_smaller.png"],
                        @"blue" : [UIImage imageNamed:@"grid_bird_smaller.png"],
                        @"yellow" : [UIImage imageNamed:@"grid_cat_smaller.png"],
                        @"orange" : [UIImage imageNamed:@"grid_fish_smaller.png"]
                        };
    
    self.tileSoundEffects = @{
                              @"red": [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sound_mouse.wav",[[NSBundle mainBundle] resourcePath]]] error:nil],
                              @"green": [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sound_dog.wav",[[NSBundle mainBundle] resourcePath]]] error:nil],
                              @"blue": [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sound_bird.wav",[[NSBundle mainBundle] resourcePath]]] error:nil],
                              @"yellow": [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sound_cat.wav",[[NSBundle mainBundle] resourcePath]]] error:nil],
                              @"orange": [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sound_fish.wav",[[NSBundle mainBundle] resourcePath]]] error:nil]
                              };
    
    [self initGame];
}

-(void)viewDidAppear:(BOOL)animated {
    [self resumeTimer:self.gameModel.timer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initGame {
    self.gameModel = [[GameModel alloc] init];
    
    self.gameModel.width = 7;
    self.gameModel.height = 8;
    
    self.gameModel.startTime = 30;
    
    //size of each individual tile
    self.tileSize = ([UIScreen mainScreen].bounds.size.width - 20) / self.gameModel.width;
    
    //left padding of the game field
    //worked out by the different of the game screen width and width of all the tiles
    self.leftPadding = ([UIScreen mainScreen].bounds.size.width - 20) - (self.gameModel.width * self.tileSize) + 1;
    
    self.gameModel.gameArray = [@[
                         [@[ @"yellow", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ] mutableCopy],
                         [@[ @"red", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ]mutableCopy],
                         [@[ @"red", @"red", @"blue", @"yellow", @"orange", @"red", @"red" ]mutableCopy],
                         [@[ @"yellow", @"red", @"blue", @"yellow", @"orange", @"red", @"red" ]mutableCopy],
                         [@[ @"red", @"red", @"blue", @"yellow", @"orange", @"red", @"red" ]mutableCopy],
                         [@[ @"red", @"green", @"yellow", @"yellow", @"orange", @"red", @"red" ]mutableCopy],
                         [@[ @"red", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ]mutableCopy],
                         [@[ @"red", @"green", @"blue", @"yellow", @"orange", @"red", @"red" ]mutableCopy],
                         ] mutableCopy];
    
    [self updateScore];
    [self drawTiles];
    [self initTimer];
    [self updateTimer];
}

-(void)drawTiles {
    //delete all current tiles
    [[self.gameField subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //2d array of buttons
    self.gameFieldTileImages = [[NSMutableArray alloc] init];
    
    //render all the tiles
    for (int row = 0; row < self.gameModel.height; row++) {
        NSMutableArray* tileImagesRow = [[NSMutableArray alloc] init];
        
        for (int column = 0; column < self.gameModel.width; column++) {
            NSString* tileType = [[self.gameModel.gameArray objectAtIndex:row] objectAtIndex:column];
            
            TileButton *button = [TileButton buttonWithType:UIButtonTypeCustom];
            //set the array position of the tile
            [button setRow:row];
            [button setColumn:column];
            //button calls function buttonClicked on click
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            //no text in the button
            [button setTitle:@"" forState:UIControlStateNormal];
            //set the correct image for the tile
            [button setBackgroundImage: [self.tileImages objectForKey: tileType] forState:UIControlStateNormal];
            //set position of the tile based of array position and tile size
            button.frame = CGRectMake(self.leftPadding + (column * self.tileSize), row * self.tileSize, self.tileSize, self.tileSize);
            
            //add button to the game field
            [self.gameField addSubview:button];
            //add button to row array of buttons
            [tileImagesRow addObject:button];
        }
        
        //add row of buttons to 2d array of buttons
        [self.gameFieldTileImages addObject:tileImagesRow];
    }
}

-(void)buttonClicked:(TileButton*)sender {
    //prevent player from clicking again while animations are playing
    if(self.gameModel.gameArrayNew != nil) {
        NSLog(@"blocked click");
        return;
    }
    
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
    
    //get the score for that cluster click
    NSMutableDictionary* clusterCheck = [self.gameModel checkClusterMatchForTile:tileType inRow:row andColumn:column];
    int score = [[clusterCheck objectForKey:@"score"] intValue];
    
    //cluster must give a score of at least 3 to actually get deleted
    if (score >= 3) {
        AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if(appDelegate.playGameAudio) {
            //play the tiles sound effect
            AVAudioPlayer* soundPlayer = [self.tileSoundEffects objectForKey:tileType];
            [soundPlayer play];
        }
        
        //Update the players score
        self.gameModel.score += score;
        [self updateScore];
        
        //animate the cluster desctruction
        double animationLength = 0.4;
        [self animateTileDestruction:[clusterCheck objectForKey:@"tilestobedestroyed"] withAnimationLength:animationLength];
        
        //drop tiles once shrink animations have been completed
        dispatch_time_t dropDelayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)((animationLength * 0.5) * NSEC_PER_SEC));
        dispatch_after(dropDelayTime, dispatch_get_main_queue(), ^(void){
            [self dropCurrentTiles:0.2];
        });
    } else {
        //delete everything we learnt from that click
        self.gameModel.gameArrayNew = nil;
    }
    
    NSLog(@"button clicked %@ %i %i %i", tileType, row, column, score);
}

-(void)animateTileDestruction:(NSMutableArray*) tilesToBeDestroyed withAnimationLength:(double)animationLength {
    for (int i = 0; i < [tilesToBeDestroyed count]; i++) {
        NSValue* pointValue = [tilesToBeDestroyed objectAtIndex:i];
        CGPoint point;
        [pointValue getValue:&point];
        
        int row = point.x;
        int column = point.y;
        
        TileButton* tile = [[self.gameFieldTileImages objectAtIndex:row] objectAtIndex:column];
        
        //animate tile shrinking
        [UIView animateWithDuration:animationLength animations:^ {
            tile.transform = CGAffineTransformMakeScale(0.01, 0.01);
        } completion:^(BOOL finished) {
            tile.alpha = 0.0; //hide the tile for now
        }];
        
    }
}

-(void)dropCurrentTiles:(double)animationLength {
    //to make sure all tiles have falled, run through a number of times equal to the height of the game field
    for (int i = 0; i < self.gameModel.height; i++) {
        
        //go through all the tiles
        for (int row = self.gameModel.height-1; row >= 1; row--) {
            for (int column = self.gameModel.width-1; column >= 0; column--) {
                NSString* tileType = [[self.gameModel.gameArrayNew objectAtIndex:row] objectAtIndex:column];
                
                //if deleted tile, swap it with the one above - this simulates falling
                if([tileType isEqualToString:@"deleted"]) {
                    NSString* tileAboveType = [[self.gameModel.gameArrayNew objectAtIndex:row-1] objectAtIndex:column];
                    
                    //replace current tile with one above
                    [[self.gameModel.gameArrayNew objectAtIndex:row] replaceObjectAtIndex:column withObject:tileAboveType];
                    //replace tile above with deleted
                    [[self.gameModel.gameArrayNew objectAtIndex:row-1] replaceObjectAtIndex:column withObject:@"deleted"];
                    
                    //animate tile falling
                    TileButton* tileCurrent = [[self.gameFieldTileImages objectAtIndex:row] objectAtIndex:column];
                    TileButton* tileAbove = [[self.gameFieldTileImages objectAtIndex:row-1] objectAtIndex:column];
                    [UIView animateWithDuration:animationLength animations:^ {
                        CGRect frame = tileAbove.frame;
                        frame.origin.y += self.tileSize;
                
                        tileAbove.frame = frame;
                    }];
                    
                    [[self.gameFieldTileImages objectAtIndex:row] replaceObjectAtIndex:column withObject:tileAbove];
                    [[self.gameFieldTileImages objectAtIndex:row-1] replaceObjectAtIndex:column withObject:tileCurrent];
                }
            }
        }
    }
    
    //drop tiles once dropping of current tiles animations have been completed
    dispatch_time_t dropDelayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationLength * NSEC_PER_SEC));
    dispatch_after(dropDelayTime, dispatch_get_main_queue(), ^(void){
        [self dropNewTiles:animationLength];
    });
}

-(void)dropNewTiles:(double)animationLength {
    //go through all the tiles in the game board
    for (int row = 0; row < self.gameModel.height; row++) {
        for (int column = 0; column < self.gameModel.width; column++) {
            NSString* tileType = [[self.gameModel.gameArrayNew objectAtIndex:row] objectAtIndex:column];
            
            //if deleted tile then replace with a random kind
            if([tileType isEqualToString:@"deleted"]) {
                //generate new random tile type
                //I SHOULD BE IN THE MODEL!!!!!!!!
                NSArray* tileTypes = @[@"red", @"yellow", @"orange", @"green", @"blue"];
                int lowerBound = 0;
                int upperBound = (int)[tileTypes count];
                int tileNumber = lowerBound + arc4random() % (upperBound - lowerBound);
                NSString* newTileType = [tileTypes objectAtIndex:tileNumber];
                [[self.gameModel.gameArrayNew objectAtIndex:row] replaceObjectAtIndex:column withObject:newTileType];
                
                //update tile image to new type
                TileButton* tile = [[self.gameFieldTileImages objectAtIndex:row] objectAtIndex:column];
                [tile setBackgroundImage: [self.tileImages objectForKey: newTileType] forState:UIControlStateNormal];
                
                //make the tile visible again
                tile.alpha = 1.0; //unhide the tile
                tile.transform = CGAffineTransformMakeScale(1.0, 1.0); //make the tile the right size again
                
                //move tile to above the game field
                CGRect frame = tile.frame;
                frame.origin.y = -(self.tileSize * (self.gameModel.height - row));
                tile.frame = frame;
                
                //make the tile drop to it's proper position
                [UIView animateWithDuration:animationLength animations:^ {
                    CGRect frame = tile.frame;
                    frame.origin.y = (self.tileSize * row);
                    tile.frame = frame;
                }];
            }
        }
    }
    
    //after all the animations have complete return the game state back to normal
    dispatch_time_t dropDelayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)((animationLength * 1.0) * NSEC_PER_SEC));
    dispatch_after(dropDelayTime, dispatch_get_main_queue(), ^(void){
        //replace current game array with new one
        self.gameModel.gameArray = self.gameModel.gameArrayNew;
        //delete the gameArrayNew variable value - allow the player to touch a cluster again
        self.gameModel.gameArrayNew = nil;
        
        //redraw all the tiles
        [self drawTiles];
    });
}

-(void)updateScore {
    [self.scoreLabel setText:[NSString stringWithFormat:@"%i", self.gameModel.score]];
}

-(void)updateTimer {
    //display time as minutes:seconds
    int seconds = self.gameModel.currentTime % 60;
    int minutes = (self.gameModel.currentTime / 60) % 60;
    [self.timerLabel setText:[NSString stringWithFormat:@"%2d:%02d", minutes, seconds]];
}

-(void)initTimer{
    //start the countdown timer
    self.gameModel.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    self.gameModel.currentTime = self.gameModel.startTime;
}

-(void)timerFired{
    //decrease the current time by one second
    self.gameModel.currentTime--;
    //redraw the timer
    [self updateTimer];
    
    //if the timer hits zero, send the user to the score page
    if(self.gameModel.currentTime == 0) {
        [self performSegueWithIdentifier:@"segueToScore" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"segueToScore"]) {
        //if we are transfering to score page - set the score
        ScoreViewController* scoreViewController = [segue destinationViewController];
        
        [scoreViewController setScoreResult:self.gameModel.score];
        [scoreViewController setTotalTime:self.gameModel.startTime];
    } else if ([[segue identifier] isEqualToString:@"segueToPause"]) {
        //if we are transfering to pause page - actually pause the timer
        [self pauseTimer:self.gameModel.timer];
    }
}

-(void)pauseTimer:(NSTimer*)timer {
    self.pauseStart = [NSDate dateWithTimeIntervalSinceNow:0];
    self.previousFireDate = [self.gameModel.timer fireDate];
    [self.gameModel.timer setFireDate:[NSDate distantFuture]];
}

-(void)resumeTimer:(NSTimer*)timer {
    float pauseTime = -1*[self.pauseStart timeIntervalSinceNow];
    [self.gameModel.timer setFireDate:[self.previousFireDate initWithTimeInterval:pauseTime sinceDate: self.previousFireDate]];
}

@end
