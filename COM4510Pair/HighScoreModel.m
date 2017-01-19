//
//  HighScoreModel.m
//  COM4510Pair
//
//  Created by aca13ytw on 19/01/2017.
//  Copyright © 2017 aca13ytw. All rights reserved.
//

#import "HighScoreModel.h"

@implementation HighScoreModel

-(void)addHighScoreOf:(int)score withName:(NSString*)name {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* scores = [[defaults arrayForKey:@"highscores"] mutableCopy];
    
    //if no initial value of scores - create it
    if(scores == nil) {
        scores = [[NSMutableArray alloc] init];
    }
    
    NSMutableDictionary* newScore = [[NSMutableDictionary alloc] init];
    [newScore setValue:[NSNumber numberWithInt:score] forKey:@"score"];
    [newScore setValue:name forKey:@"name"];
    
    [scores addObject:newScore];
    
    [defaults setObject:[scores copy] forKey:@"highscores"];
    [defaults synchronize];
}

-(NSArray*)getHighScores {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSArray* scores = [defaults arrayForKey:@"highscores"];
    
    return scores;
}

@end
