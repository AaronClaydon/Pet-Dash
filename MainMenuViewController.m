//
//  MainMenuViewController.m
//  COM4510Pair
//
//  Created by Aaron Claydon on 04/02/2017.
//  Copyright © 2017 aca13ytw. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self authenticateLocalPlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)authenticateLocalPlayer{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else {
            AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            if ([GKLocalPlayer localPlayer].authenticated) {
                appDelegate.gameCenterEnabled = YES;
            }
            else {
                appDelegate.gameCenterEnabled = NO;
            }
        }
    };
}

-(IBAction)clickScoreboard:(id)sender {
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(appDelegate.gameCenterEnabled) {
        [self showLeaderboardAndAchievements:YES];
    } else {
        UIAlertController* scoreAlert = [UIAlertController alertControllerWithTitle:@"Not Signed In" message:@"You must be signed in to Game Center to view the scoreboard" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action) {
            [scoreAlert dismissViewControllerAnimated:YES completion:nil];
        }];

        [scoreAlert addAction:cancelButton];

        [self presentViewController:scoreAlert animated:YES completion:nil];
    }
}

-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard{
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = self;
    
    if (shouldShowLeaderboard) {
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gcViewController.leaderboardIdentifier = @"ACYW_petdash_topscore";
    }
    else {
        gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
    }
    
    [self presentViewController:gcViewController animated:YES completion:nil];
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
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
