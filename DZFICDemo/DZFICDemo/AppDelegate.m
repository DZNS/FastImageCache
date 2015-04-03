//
//  AppDelegate.m
//  DZFICDemo
//
//  Created by Nikhil Nigade on 4/3/15.
//  Copyright (c) 2015 Dezine Zync Studios LLP. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    FlowLayout *layout = [[FlowLayout alloc] init];
    
    self.window.rootViewController = [[ViewController alloc] initWithCollectionViewLayout:layout];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
