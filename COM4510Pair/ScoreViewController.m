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
#import "HighScoreModel.h"

@interface ScoreViewController ()

@end

@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self displayScoreResult];
    
    self.muteButton.hidden = YES;
}

-(void)displayScoreResult {
    HighScoreModel* highScores = [[HighScoreModel alloc] init];
    [highScores addHighScoreOf:4545 withName:@"test"];
    [highScores getHighScores];
    
    int seconds = self.gameModel.startTime % 60;
    int minutes = (self.gameModel.startTime / 60) % 60;
    
    [self.scoreResultLabel setText:[NSString stringWithFormat:@"Wow! You got a score of %i\nin a time of %2d:%02d", self.gameModel.score, minutes, seconds]];
    
    [self.totalTimeLabel setText:[NSString stringWithFormat:@"in a time of %2d:%02d", minutes, seconds]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)FBPressed{
    int seconds = self.gameModel.startTime % 60;
    int minutes = (self.gameModel.startTime / 60) % 60;
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *fbPostSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [fbPostSheet setInitialText:[NSString stringWithFormat:@"I got a score of %i in the time of %2d:%02d , come and join me in Pet Dash!",self.gameModel.score, minutes, seconds]];
        [self presentViewController:fbPostSheet animated:YES completion:nil];
    } else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't post right now, make sure your device has an internet connection and you have at least one facebook account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

-(IBAction)TweetPressed{
    int seconds = self.gameModel.startTime % 60;
    int minutes = (self.gameModel.startTime / 60) % 60;
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"I got a score of %i in the time of %2d:%02d , come and join me in Pet Dash!",self.gameModel.score, minutes, seconds]];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"segueToRestartGame"]) {
        //if we are transfering to score page - set the score
        GameViewController* gameViewController = [segue destinationViewController];
        
        [gameViewController setGameModel:self.gameModel];
    }
}

@end
