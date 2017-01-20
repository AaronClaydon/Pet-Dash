//
//  testHighScoreModel.m
//  COM4510Pair
//
//  Created by Aaron Claydon on 20/01/2017.
//  Copyright © 2017 aca13ytw. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HighScoreModel.h"

@interface testHighScoreModel : XCTestCase

@property HighScoreModel* highScoreModel;

@end

@implementation testHighScoreModel

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.highScoreModel = [[HighScoreModel alloc] init];
}

- (void)tearDown {
    [self.highScoreModel clearScores];
    self.highScoreModel = nil;

    [super tearDown];
}

-(void)testAddHighScore {
    [self.highScoreModel addHighScoreOf:100 withName:@"aplayer"];
    
    NSArray* scores = [self.highScoreModel getHighScores];
    
    XCTAssertEqual([scores count], 1); //should have one score
}

-(void)testAddHighScoreOrdered {
    //scores should be ordered by score
    
    [self.highScoreModel addHighScoreOf:160 withName:@"player1"];
    [self.highScoreModel addHighScoreOf:100 withName:@"player2"];
    [self.highScoreModel addHighScoreOf:300 withName:@"player3"];
    
    NSArray* scores = [self.highScoreModel getHighScores];
    NSMutableDictionary* firstScore = [scores objectAtIndex:0];
    NSMutableDictionary* secondScore = [scores objectAtIndex:1];
    NSMutableDictionary* thirdScore = [scores objectAtIndex:2];
    
    XCTAssertEqualObjects([firstScore objectForKey:@"name"], @"player3");
    XCTAssertEqualObjects([secondScore objectForKey:@"name"], @"player1");
    XCTAssertEqualObjects([thirdScore objectForKey:@"name"], @"player2");
}

-(void)testAddHighScoreMax6 {
    //should be a maximum of 6 scores stored
    
    [self.highScoreModel addHighScoreOf:160 withName:@"player1"];
    [self.highScoreModel addHighScoreOf:100 withName:@"player2"];
    [self.highScoreModel addHighScoreOf:300 withName:@"player3"];
    [self.highScoreModel addHighScoreOf:160 withName:@"player4"];
    [self.highScoreModel addHighScoreOf:100 withName:@"player5"];
    [self.highScoreModel addHighScoreOf:300 withName:@"player6"];
    [self.highScoreModel addHighScoreOf:160 withName:@"player7"];
    [self.highScoreModel addHighScoreOf:100 withName:@"player8"];
    [self.highScoreModel addHighScoreOf:300 withName:@"player9"];
    
    NSArray* scores = [self.highScoreModel getHighScores];
    XCTAssertEqual([scores count], 6);
}

-(void)testGetHighScore {
    [self.highScoreModel addHighScoreOf:100 withName:@"aplayer"];
    
    NSArray* scores = [self.highScoreModel getHighScores];
    NSMutableDictionary* firstScore = [scores objectAtIndex:0];
    
    XCTAssertEqual([scores count], 1); //should have one score
    XCTAssertEqualObjects([firstScore objectForKey:@"name"], @"aplayer"); //correct name
    XCTAssertEqual([[firstScore objectForKey:@"score"] intValue], 100); //correct score
}

-(void)testClearHighScore {
    [self.highScoreModel addHighScoreOf:100 withName:@"aplayer"];
    
    [self.highScoreModel clearScores];
    
    NSArray* scores = [self.highScoreModel getHighScores];
    XCTAssertEqual([scores count], 0); //should have no scores
    
}

@end
