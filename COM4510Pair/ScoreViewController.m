//
//  ScoreViewController.m
//  COM4510Pair
//
//  Created by aca13ytw on 12/01/2017.
//  Copyright © 2017 aca13ytw. All rights reserved.
//

#import "ScoreViewController.h"
#import "GameModel.h"
#import "GameViewController.h"
#import "AppDelegate.h"
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface ScoreViewController ()

@end

@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self displayScoreResult];
    
    self.muteButton.hidden = YES;
    
    self.alreadySavedScore = NO;
}

-(void)displayScoreResult {
    int seconds = self.gameModel.startTime % 60;
    int minutes = (self.gameModel.startTime / 60) % 60;
    
    [self.scoreResultLabel setText:[NSString stringWithFormat:@"Wow! You got a score of %i\nin a time of %2d:%02d", self.gameModel.score, minutes, seconds]];
    
    [self.totalTimeLabel setText:[NSString stringWithFormat:@"in a time of %2d:%02d", minutes, seconds]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)FBPressed {
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/pet-dash/id1199656030"];
    content.quote = [NSString stringWithFormat:@"I got a score of %i in Pet Dash, come and join me!",self.gameModel.score];
    [FBSDKShareDialog showFromViewController:self
                                 withContent:content
                                    delegate:nil];
}

-(IBAction)TweetPressed {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"I got a score of %i in Pet Dash, come and join me! Get it at https://itunes.apple.com/us/app/pet-dash/id1199656030",self.gameModel.score]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
        
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    
}

-(IBAction)saveScore {
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(!appDelegate.gameCenterEnabled) {
        UIAlertController* scoreAlert = [UIAlertController alertControllerWithTitle:@"Not Saved" message:@"You must be signed in to Game Center to submit your score" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action) {
            [scoreAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [scoreAlert addAction:cancelButton];
        
        [self presentViewController:scoreAlert animated:YES completion:nil];
        
        return;
    }
    
    if(!self.alreadySavedScore) {
        GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:@"ACYW_petdash_topscore"];
        score.value = self.gameModel.score;
        
        [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            } else {
                self.alreadySavedScore = YES;
                
                UIAlertController* scoreAlert = [UIAlertController alertControllerWithTitle:@"Score Saved" message:@"Your highscore has been submitted" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action) {
                    [scoreAlert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [scoreAlert addAction:cancelButton];
                
                [self presentViewController:scoreAlert animated:YES completion:nil];
            }
        }];
    } else {
        UIAlertController* scoreAlert = [UIAlertController alertControllerWithTitle:@"Not Saved" message:@"You have already submitted this score" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action) {
            [scoreAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [scoreAlert addAction:cancelButton];
        
        [self presentViewController:scoreAlert animated:YES completion:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"segueToRestartGame"]) {
        //if we are transfering to score page - set the score
        GameViewController* gameViewController = [segue destinationViewController];
        
        [gameViewController setGameModel:self.gameModel];
    }
}

@end
