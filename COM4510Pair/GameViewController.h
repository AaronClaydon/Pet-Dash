//
//  GameViewController.h
//  COM4510Pair
//
//  Created by aca13ytw on 18/11/2016.
//  Copyright © 2016 aca13ytw. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "BackgroundViewController.h"
#import "TileButton.h"
#import "GameModel.h"
#import "ScoreViewController.h"

@interface GameViewController : BackgroundViewController

@property (weak) IBOutlet UILabel* scoreLabel;
@property (weak) IBOutlet UILabel* timerLabel;
@property (weak) IBOutlet UIView* gameField;

@property (strong) GameModel* gameModel;

@property (strong) NSDate* pauseStart;
@property (strong) NSDate* previousFireDate;

@property (strong) NSMutableArray* gameFieldTileImages;
@property (strong) NSDictionary* tileImages;
@property (strong) NSDictionary* tileSoundEffects;

@property int tileSize;
@property int leftPadding;

-(void)initGame;
-(void)buttonClicked:(TileButton*)sender;
-(void)drawTiles;

-(void)initTimer;
-(void)timerFired;
-(void)pauseTimer:(NSTimer*)timer;
-(void)resumeTimer:(NSTimer*)timer;

-(void)animateTileDestruction:(NSMutableArray*) tilesToBeDestroyed withAnimationLength:(double)animationLength;
-(void)dropCurrentTiles:(double)animationLength;
-(void)dropNewTiles:(double)animationLength;

@end
