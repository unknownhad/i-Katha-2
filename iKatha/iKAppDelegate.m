//
//  iKAppDelegate.m
//  iKatha
//
//  Created by Boove Software on 28/11/13.
//  Copyright (c) 2013 Boove Software. All rights reserved.
//

#import "iKAppDelegate.h"
#import "StoryObject.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>



@implementation iKAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
      _audioSession = [AVAudioSession sharedInstance];
    
    self.storiesArray = [NSMutableArray new];
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     self.fileManager = [NSFileManager defaultManager];
   // self.documentsDirectory = [paths objectAtIndex:0];
    [Fabric with:@[CrashlyticsKit]];

    
    return YES;
}



- (void)initializeDatabase
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // Database filename can have extension db/sqlite.
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appDBPath = [documentsDirectory stringByAppendingPathComponent:@"ikatha_story.sqlite3"];
    
    success = [fileManager fileExistsAtPath:appDBPath];
    
    if (success) {
        self.strDBPath = appDBPath;
        return;
    }
     // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ikatha_story.sqlite3"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:appDBPath error:&error];
    
    if (!error) {
        
        self.strDBPath = appDBPath;
        NSLog(@"path is %@",self.strDBPath);
    }
    
    
    NSAssert(success, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    //return defaultDBPath;

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


+ (void)showAlertDialog:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc]init];
    alertView.title = @"iKatha";
    alertView.message = msg;
    [alertView addButtonWithTitle:@"Okay"];
    [alertView show];
    
}


- (NSString *)copyToDocumentsDirectory:(NSString *)strName ofType:(NSString *)type
{
   
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // Database filename can have extension db/sqlite.
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *txtPath = [documentsDirectory stringByAppendingPathComponent:strName];
    
    if ([self.fileManager fileExistsAtPath:txtPath] == NO) {
        NSString *resourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:strName];
       
        [self.fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
    }
   // NSLog(@"Documents directory..: %@", [self.fileManager contentsOfDirectoryAtPath:documentsDirectory error:&error]);
    return txtPath;
}

- (UIImage *)loadImageWithName:(NSString *)strName
{
    NSError *error;
    
    NSLog(@"str name is %@",strName);
    
    //strName = [strName stringByAppendingString:@".png"];
    
   
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                     strName ];
    
    UIImage* image;
    if ([strName rangeOfString:@"Document"].location != NSNotFound) {
        
        image = [UIImage imageWithContentsOfFile:strName];
    }
    else
    {
    image = [UIImage imageWithContentsOfFile:path];
    }
    
    // Write out the contents of home directory to console
   // NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
    
    return image;
}


- (void)getStories
{
    FMResultSet *results = [self.fmdatabase executeQuery:@"SELECT * FROM story_master"];
    
    [self.storiesArray removeAllObjects];
    while([results next]) {
        
        StoryObject *object = [StoryObject new];
        
        int strId = [results intForColumn:@"id"];
        NSString *strTitle = [NSString stringWithFormat:@"%@",[results stringForColumn:@"title"]];
        
        strTitle = [self getFilteredString:strTitle];
        NSString *strStoryText = [NSString stringWithFormat:@"%@",[results stringForColumn:@"story_text"]];
        NSString *story_img_path = [NSString stringWithFormat:@"%@",[results stringForColumn:@"story_img_path"]];
        
        NSString *story_audio_path = [NSString stringWithFormat:@"%@",[results stringForColumn:@"audio_path"]];
        int numOfPages =[results intForColumn:@"num_of_pages"];
        
        object.storyId = strId;
        object.strTitle = strTitle;
        object.strText = strStoryText;
        object.strImagePath = story_img_path;
        object.strAudioPath = story_audio_path;
        object.numOfPages = numOfPages;
        object.arrAudioPaths = [[object.strAudioPath componentsSeparatedByString:@"|"] mutableCopy];
        
//        for (int j=0; j<object.arrAudioPaths.count; j++) {
//            
//            NSString *str = [object.arrAudioPaths objectAtIndex:j];
//            str = [str stringByAppendingString:@""];
//            if ([str rangeOfString:@"Document"].location!=NSNotFound) {
//                
//            }
//            else
//            {
//                // str = [str stringByAppendingString:@".mp3"];
//            [object.arrAudioPaths replaceObjectAtIndex:j withObject:[self.documentsDirectory stringByAppendingPathComponent:str]];
//            }
//            
//            
//        }
        

        object.arrImagePaths = [[object.strImagePath componentsSeparatedByString:@"|"] mutableCopy];
        object.arrSentences = [[object.strText componentsSeparatedByString:@"|"] mutableCopy];
        
        [self.storiesArray addObject:object];
        
      //  NSLog(@"story title %@",strTitle);
        
        
    
    }
    

}


+ (UIViewController *)getViewControllerFromStoryboard:(NSString *)identifier
{
    NSString *name = @"Main";
    
//    if ([self isiPad]) {
//        
//        name = @"Main_iPad";
//    }
//    else
//    {
//        name = @"Main";
//    }
    
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:name bundle:nil];
    
    return [mystoryboard instantiateViewControllerWithIdentifier:identifier];
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    
    return UIInterfaceOrientationMaskAll;
}


- (NSString *)getFilteredString:(NSString *)unfilteredString
{
    
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_. "] invertedSet];
    NSString *resultString = [[unfilteredString componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    NSLog (@"Result: %@", resultString);
    return resultString;
    
}


+ (NSString *)getDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // Database filename can have extension db/sqlite.
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
}
@end
