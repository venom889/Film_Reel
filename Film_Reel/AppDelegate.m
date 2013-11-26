//
//  AppDelegate.m
//  Film_Reel
//
//  Created by Ben Sweett on 2013-10-05.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;
@synthesize token;
@synthesize validToken;

+(AppDelegate *) appDelegate
{
    return (AppDelegate *) [[UIApplication sharedApplication] delegate];
}

- (NSString*) buildTokenLoginRequest: (NSString*) tokenToCheck
{
    NSMutableString* valid = [[NSMutableString alloc] initWithString:@SERVER_ADDRESS];
    [valid appendString:@"tokenlogin?"];
    
    NSMutableString* parameter1 = [[NSMutableString alloc] initWithFormat: @"token=%@" , tokenToCheck];
    
    [valid appendString:parameter1];
    
    NSLog(@"TokenLogin request:: %@", valid);
    
    return valid;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSUserDefaults* currentLoggedIn = [NSUserDefaults standardUserDefaults];
    if(token != nil)
    {
        NSLog(@"Token into background %@", token);
        [currentLoggedIn setObject:token forKey:@CURRENT_USER];
        [currentLoggedIn synchronize];
    }
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@ADDRESS_FAIL object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@FAIL_STATUS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@USER_ALREADY_EXISTS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@SIGNUP_SUCCESS object:nil];
    */
     
    NSUserDefaults* currentLoggedIn = [NSUserDefaults standardUserDefaults];
    token = [currentLoggedIn objectForKey:@CURRENT_USER];
    
    if(token != nil)
    {
        validToken = [[Networking alloc] init];
        NSLog(@"Token after background %@", token);
        NSString* request = [self buildTokenLoginRequest:token];
        [validToken startReceive:request withType:@VALID_REQUEST];
        
        if([validToken isReceiving])
        {
            
        }
    }
    else
    {
        
    }
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// Handles all Networking errors that come from Networking.m
-(void) didGetNetworkError: (NSNotification*) notif
{
    if([[notif name] isEqualToString:@ADDRESS_FAIL])
    {

    }
    if([[notif name] isEqualToString:@FAIL_STATUS])
    {
     
    }
}

// Dismiss dialogs when done
-(void) dismissErrors:(UIAlertView*) alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

// Handles Succussful acount creation
-(void) didSucceedRequest: (NSNotification*) notif
{
    if([[notif name] isEqualToString:@SIGNUP_SUCCESS])
    {

    }
    
    if([[notif name] isEqualToString:@USER_ALREADY_EXISTS])
    {

    }
}


@end
