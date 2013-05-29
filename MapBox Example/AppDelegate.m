//
//  AppDelegate.m
//  MapBox Example
//
//  Created by Justin Miller on 3/27/12.
//  Copyright (c) 2012 MapBox / Development Seed. All rights reserved.
//

#import "AppDelegate.h"

#import "ComparisonViewController.h"

@implementation AppDelegate
{
    UINavigationController *navC;
}

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    ComparisonViewController *startViewC = [[ComparisonViewController alloc] init];
    navC = [[UINavigationController alloc] initWithRootViewController:startViewC];
    navC.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.window.rootViewController = navC;
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end