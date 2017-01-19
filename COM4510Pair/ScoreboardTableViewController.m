//
//  ScoreboardTableViewController.m
//  COM4510Pair
//
//  Created by aca13ytw on 19/01/2017.
//  Copyright © 2017 aca13ytw. All rights reserved.
//

#import "ScoreboardTableViewController.h"

@interface ScoreboardTableViewController ()

@end

@implementation ScoreboardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.highScoreModel = [[HighScoreModel alloc] init];
    
    UIImage *originalImage = [UIImage imageNamed:@"background image.png"];
    // scaling set to 2.0 makes the image 1/2 the size.
    UIImage *scaledImage = [UIImage imageWithCGImage:[originalImage CGImage]
                                               scale:(originalImage.scale * 2.0)
                                         orientation:(originalImage.imageOrientation)];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage: scaledImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)closeButtonTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)clearButtonTapped:(id)sender {
    [self.highScoreModel clearScores];
    
    //reload the table
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.highScoreModel getHighScores] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"scoreboardRow"];
    
    if(indexPath.row == 0) {
        cell.textLabel.text = @"NAME";
        
        cell.detailTextLabel.text = @"SCORE";
        cell.detailTextLabel.textColor = [UIColor blackColor];
        
        [cell.textLabel setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:16]];
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:16]];
    } else {
        NSArray* highScores = [self.highScoreModel getHighScores];
        NSMutableDictionary* currentScore = [highScores objectAtIndex:indexPath.row-1];
        
        int score = [[currentScore objectForKey:@"score"] intValue];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", score];
        cell.textLabel.text = [currentScore objectForKey:@"name"];
        
        [cell.textLabel setFont:[UIFont fontWithName:@"AmericanTypewriter" size:16]];
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"AmericanTypewriter" size:16]];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
