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

-(id)initWithWidth:(int)width andHeight:(int)height andStartTime:(int)startTime {
    self = [super init];
    
    if (self) {
        self.width = width;
        self.height = height;
        self.startTime = startTime;
        
        self.isPaused = NO;
    }
    
    return self;
}

-(NSMutableDictionary*)checkClusterMatchForTile:(NSString *)tile inRow:(int)row andColumn:(int)column {
    //Reset the array of tiles that have already been checked
    [self resetCheckedArray];
    
    //To return multiple values we store them in a dictionary
    NSMutableDictionary* returnValues = [[NSMutableDictionary alloc] init];
    
    //Array of all tiles that will be destroyed
    NSMutableArray* tilesToBeDestroyed = [[NSMutableArray alloc] init];
    int score = 0;
    //Array of points that need to be checked if they match the tile type
    NSMutableArray* toCheckArray = [[NSMutableArray alloc] init];
    
    //Add the first point to the stack of tiles to check
    [self addPointToCheckArray:toCheckArray withRow:row andColumn:column];
    
    self.gameArrayNew = [self copy2DArray:self.gameArray];
    
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
        
        //add to list of tiles to be killed
        [tilesToBeDestroyed addObject:pointValue];
        
        //set the tile as deleted
        NSMutableArray* rowArray = [self.gameArrayNew objectAtIndex:row];
        [rowArray replaceObjectAtIndex:column withObject:@"deleted"];
        //[self.gameArrayNew replaceObjectAtIndex:row withObject:rowArray];
        
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
    
    [returnValues setValue:[NSNumber numberWithInt:score] forKey:@"score"];
    [returnValues setValue:tilesToBeDestroyed forKey:@"tilestobedestroyed"];
    
    return returnValues;
}

-(void)resetCheckedArray {
    //Set all values in the has been checked 2D array to be false
    self.checkedArray = [[NSMutableArray alloc] init];
    
    for(int row = 0; row < self.height; row++) {
        NSMutableArray* rowArray = [[NSMutableArray alloc] init];
        
        for(int column = 0; column < self.width; column++) {
            [rowArray addObject:@false];
        }
        
        [self.checkedArray addObject:rowArray];
    }

}

-(NSMutableArray*)copy2DArray:(NSMutableArray*)originalArray {
    NSMutableArray* newArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [originalArray count]; i++) {
        [newArray addObject:[[originalArray objectAtIndex:i] mutableCopy]];
    }
    
    return newArray;
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

-(NSString*)generateRandomTile {
    NSArray* tileTypes = @[@"red", @"yellow", @"orange", @"green", @"blue"];
    int lowerBound = 0;
    int upperBound = (int)[tileTypes count];
    int tileNumber = lowerBound + arc4random() % (upperBound - lowerBound);
    NSString* newTileType = [tileTypes objectAtIndex:tileNumber];
    
    return newTileType;
}

-(void)generateGameField {
    self.gameArray = [[NSMutableArray alloc] init];
    
    for(int row = 0; row < self.height; row++) {
        NSMutableArray* rowArray = [[NSMutableArray alloc] init];
        
        for(int column = 0; column < self.width; column++) {
            NSString* tileType = [self generateRandomTile];
            
            [rowArray addObject:tileType];
        }
        
        [self.gameArray addObject:rowArray];
    }
}

-(BOOL)checkIfPossibleGameField {
    BOOL isPossible = NO;
    
    //go through all tiles and check if clicking it would give a score
    for(int row = 0; row < self.height; row++) {
        for(int column = 0; column < self.width; column++) {
            NSString* tileType = [[self.gameArray objectAtIndex:row] objectAtIndex:column];
            
            NSMutableDictionary* clusterCheck = [self checkClusterMatchForTile:tileType inRow:row andColumn:column];
            int score = [[clusterCheck objectForKey:@"score"] intValue];
            
            //at least one tile gave a score - so field is possible
            if(score >= 3) {
                isPossible = YES;
            }
        }
    }
    
    //ignore the recreated game array
    self.gameArrayNew = nil;
    
    return isPossible;
}

@end
