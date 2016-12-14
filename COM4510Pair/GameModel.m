//
//  GameModel.m
//  COM4510Pair
//
//  Created by aca13ytw on 14/12/2016.
//  Copyright © 2016 aca13ytw. All rights reserved.
//

#import "GameModel.h"

#import <CoreGraphics/CoreGraphics.h>

@implementation GameModel

-(int)checkClusterMatchForTile:(NSString *)tile inRow:(int)row andColumn:(int)column {
    int score = 0;
    NSMutableArray* toCheckArray = [[NSMutableArray alloc] init];
    
    //Add the first point to the stack of tiles to check
    [self addPointToCheckArray:toCheckArray withRow:row andColumn:column];
    
    while ([toCheckArray count] > 0) {
        //Get and remove the first value from the stack
        NSValue* pointValue = [toCheckArray objectAtIndex:0];
        CGPoint point;
        [pointValue getValue:&point];
        [toCheckArray removeObjectAtIndex:0];
        
        //TODO: CHANGE THIS TO A CUSTOM STRUCT USING INTS NOT FLOATS
        row = point.x;
        column = point.y;
        
        //Incrase the score by one
        score++;
        
        //Check the nearby touching tiles
        if(row - 1 >= 0) {
            if([[self.gameArray objectAtIndex:row - 1] objectAtIndex:column] == tile) {
                [self addPointToCheckArray:toCheckArray withRow:row-1 andColumn:column];
            }
        }
        if(row + 1 < self.height) {
            if([[self.gameArray objectAtIndex:row + 1] objectAtIndex:column] == tile) {
                [self addPointToCheckArray:toCheckArray withRow:row+1 andColumn:column];
            }
        }
        if(column - 1 >= 0) {
            if([[self.gameArray objectAtIndex:row] objectAtIndex:column - 1] == tile) {
                [self addPointToCheckArray:toCheckArray withRow:row andColumn:column-1];
            }
        }
        if(column + 1 < self.width) {
            if([[self.gameArray objectAtIndex:row] objectAtIndex:column + 1] == tile) {
                [self addPointToCheckArray:toCheckArray withRow:row andColumn:column+1];
            }
        }
        
    }
    
    return score;
}

-(void)addPointToCheckArray:(NSMutableArray*)toCheckArray withRow:(int)row andColumn:(int)column {
    //Only add points that haven't already been checked
    if([[[self.checkedArray objectAtIndex:row] objectAtIndex:column] isEqual: @false]) {
        CGPoint structValue = CGPointMake(row, column);
        NSValue *value = [NSValue valueWithBytes:&structValue objCType:@encode(CGPoint)];
        [toCheckArray addObject:value];
        
        //Set the point as being checked
        NSMutableArray* rowArray = [self.checkedArray objectAtIndex:row];
        [rowArray replaceObjectAtIndex:column withObject:@true];
        [self.checkedArray replaceObjectAtIndex:row withObject:rowArray];
    }
}


@end
