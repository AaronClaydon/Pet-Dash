//
//  GameModel.h
//  COM4510Pair
//
//  Created by aca13ytw on 14/12/2016.
//  Copyright © 2016 aca13ytw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameModel : NSObject

@property int startTime;
@property int score;
@property int currentTime;
@property NSTimer *timer;

@property int width;
@property int height;

@property (strong,retain) NSMutableArray* gameArray;
@property (strong,retain) NSMutableArray* gameArrayNew;
@property (strong) NSMutableArray* checkedArray;

-(NSMutableArray*)copy2DArray:(NSMutableArray*)originalArray;

-(id)initWithWidth:(int)width andHeight:(int)height andStartTime:(int)startTime;
-(NSMutableDictionary*)checkClusterMatchForTile:(NSString*)tile inRow:(int)row andColumn:(int)column;
-(NSString*)generateRandomTile;
-(void)generateGameField;
-(BOOL)checkIfPossibleGameField;

@end
