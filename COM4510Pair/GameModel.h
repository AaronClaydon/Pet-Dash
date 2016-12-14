//
//  GameModel.h
//  COM4510Pair
//
//  Created by aca13ytw on 14/12/2016.
//  Copyright © 2016 aca13ytw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameModel : NSObject

@property int score;
@property NSTimer *timer;

@property int width;
@property int height;

@property (strong) NSMutableArray* gameArray;
@property (strong) NSMutableArray* checkedArray;
-(int)checkClusterMatchForTile:(NSString*)tile inRow:(int)row andColumn:(int)column;
@end
