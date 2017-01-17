//
//  AppDelegate.h
//  COM4510Pair
//
//  Created by aca13ytw on 15/11/2016.
//  Copyright © 2016 aca13ytw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak) GameViewController* gameViewController;
@property BOOL playGameAudio;

@end

