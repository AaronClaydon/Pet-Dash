//
//  HighScoreModel.h
//  COM4510Pair
//
//  Created by aca13ytw on 19/01/2017.
//  Copyright © 2017 aca13ytw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HighScoreModel : NSObject

-(void)addHighScoreOf:(int)score withName:(NSString*)name;
-(NSArray*)getHighScores;
-(void)clearScores;

@end
