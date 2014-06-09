//
//  AMVAppDelegate.m
//  CareMe
//
//  Created by Matheus Fonseca on 29/05/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVAppDelegate.h"
#import "AMVHomeConsultController.h"
#import "AMVHomeMedicineController.h"
#import "AMVCareMeUtil.h"

@implementation AMVAppDelegate {
    UITabBarController *_tabController;
    UINavigationController *_consultNavController;
    UINavigationController *_medicineNavController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [AMVCareMeUtil thirdColor];
    
    [self addTabControlAndNavControlAndConfigureStyle];
        
    [self.window makeKeyAndVisible];
    
    // DELETAR TODOS OS PLISTS
//    [AMVCareMeUtil deleteAllPlists];
    
    return YES;
}

-(void) addTabControlAndNavControlAndConfigureStyle {
    _tabController = [[UITabBarController alloc] init];
    AMVHomeConsultController *homeConsultController = [[AMVHomeConsultController alloc] init];
    AMVHomeMedicineController *homeMedicineController = [[AMVHomeMedicineController alloc] init];
    
    _consultNavController = [[UINavigationController alloc] initWithRootViewController:homeConsultController];
    _medicineNavController = [[UINavigationController alloc] initWithRootViewController:homeMedicineController];
    
    [_tabController addChildViewController:_consultNavController];
    [_tabController addChildViewController:_medicineNavController];
    self.window.rootViewController = _tabController;
    
    _consultNavController.navigationBar.barTintColor = [AMVCareMeUtil firstColor];
    _consultNavController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [AMVCareMeUtil secondColor]};
    _consultNavController.navigationBar.translucent = NO;
    _consultNavController.navigationBar.tintColor = [AMVCareMeUtil secondColor];
    
    _medicineNavController.navigationBar.barTintColor = [AMVCareMeUtil firstColor];
    _medicineNavController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [AMVCareMeUtil secondColor]};
    _medicineNavController.navigationBar.translucent = NO;
    _medicineNavController.navigationBar.tintColor = [AMVCareMeUtil secondColor];
    
    _tabController.tabBar.barTintColor = [AMVCareMeUtil firstColor];
    _tabController.tabBar.translucent = NO;
    
    _tabController.tabBar.selectedImageTintColor = [AMVCareMeUtil secondColor];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
