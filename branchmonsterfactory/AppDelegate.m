//
//  AppDelegate.m
//  BranchMonsterFactory
//
//  Created by Alex Austin on 9/6/14.
//  Copyright (c) 2014 Branch, Inc All rights reserved.
//

#import "AppDelegate.h"
#import "MonsterPreferences.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Branch/Branch.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
   
    [[Branch getInstance] initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary * _Nonnull params, NSError * _Nullable error) {

        NSLog(@"%@", params);
        UIViewController *nextVC;

        if ([params objectForKey:@"monster"]) {
            [MonsterPreferences setMonsterName:[params objectForKey:@"monster_name"]];
            [MonsterPreferences setFaceIndex:[[params objectForKey:@"face_index"] intValue]];
            [MonsterPreferences setBodyIndex:[[params objectForKey:@"body_index"] intValue]];
            [MonsterPreferences setColorIndex:[[params objectForKey:@"color_index"] intValue]];

            nextVC = [storyboard instantiateViewControllerWithIdentifier:@"MonsterViewerViewController"];

        } else {

            if (![MonsterPreferences getMonsterName]) {
                [MonsterPreferences setMonsterName:@""];
                
                nextVC = [storyboard instantiateViewControllerWithIdentifier:@"MonsterCreatorViewController"];

            } else {
                nextVC = [storyboard instantiateViewControllerWithIdentifier:@"MonsterViewerViewController"];
            }
        }
        [navController setViewControllers:@[nextVC] animated:YES];
    }];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [[Branch getInstance] application:app openURL:url options:options];
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    // handler for Universal Links
    [[Branch getInstance] continueUserActivity:userActivity];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // handler for Push Notifications
    [[Branch getInstance] handlePushNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
