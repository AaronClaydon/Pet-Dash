//
//  testGameModel.m
//  COM4510Pair
//
//  Created by Aaron Claydon on 20/01/2017.
//  Copyright © 2017 aca13ytw. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GameModel.h"

@interface testGameModel : XCTestCase

@property GameModel* gameModel;

@end

@implementation testGameModel

- (void)setUp {
    [super setUp];

    //create the game model object
    self.gameModel = [[GameModel alloc] initWithWidth:3 andHeight:3 andStartTime:180];
    
    self.gameModel.gameArray = [@[
                                  [@[@"red", @"red", @"red"] mutableCopy],
                                  [@[@"blue", @"yellow", @"red"] mutableCopy],
                                  [@[@"blue", @"green", @"red"] mutableCopy],
                                  ] mutableCopy];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    self.gameModel = nil;
}

- (void)testInitWithParamters {    
    XCTAssertEqual(self.gameModel.width, 3);
    XCTAssertEqual(self.gameModel.height, 3);
    XCTAssertEqual(self.gameModel.startTime, 180);
}

-(void)testCheckClusterMatch {
    NSMutableDictionary* results = [self.gameModel checkClusterMatchForTile:@"red" inRow:0 andColumn:0];
    int score = [[results objectForKey:@"score"] intValue];
    NSMutableArray* tilesToBeDestroyed = [results objectForKey:@"tilestobedestroyed"];
    
    XCTAssertEqual(score, 5); //score must be 5
    XCTAssertEqual([tilesToBeDestroyed count], 5); //should be 5 tiles to be destroyed
}

-(void)testGenerateRandomTile {
    NSString* tile = [self.gameModel generateRandomTile];
    NSArray* tileTypes = @[@"red", @"yellow", @"orange", @"green", @"blue"];
    
    //tile generated is of a correct type
    XCTAssert([tileTypes containsObject:tile]);
}

-(void)testCheckIfGameFieldPossible1 {
    //this game field should be possible
    BOOL isPossible = [self.gameModel checkIfPossibleGameField];
    
    XCTAssert(isPossible);
}

-(void)testCheckIfGameFieldPossible2 {
    self.gameModel.gameArray = [@[
                                  [@[@"red", @"blue", @"red"] mutableCopy],
                                  [@[@"blue", @"yellow", @"orange"] mutableCopy],
                                  [@[@"blue", @"green", @"red"] mutableCopy],
                                  ] mutableCopy];
    
    //this game field should be not possible
    BOOL isPossible = [self.gameModel checkIfPossibleGameField];
    
    XCTAssertFalse(isPossible);
}

- (void)testPerformanceOfGeneratingGameField {
    [self measureBlock:^{
        [self.gameModel generateGameField];
    }];
}

- (void)testPerformanceOfCheckingCluster {
    [self measureBlock:^{
        [self.gameModel checkClusterMatchForTile:@"red" inRow:0 andColumn:0];
    }];
}

@end
