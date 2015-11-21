//
//  iKAppDelegate.h
//  iKatha
//
//  Created by Boove Software on 28/11/13.
//  Copyright (c) 2013 Boove Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "FMDatabase.h"
#import <AVFoundation/AVFoundation.h>


@interface iKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)NSString *strDBPath;
@property (strong, nonatomic)FMDatabase *fmdatabase;
@property (strong, nonatomic)NSMutableArray *storiesArray;
@property (strong, nonatomic)AVAudioSession *audioSession;
@property (strong, nonatomic)NSUserDefaults *userDefaults;
@property (strong, nonatomic)NSFileManager *fileManager;
@property (nonatomic)BOOL *isAdding;
@property(nonatomic,strong) id collectionController;

+ (void)showAlertDialog:(NSString *)msg;

+ (UIViewController *)getViewControllerFromStoryboard:(NSString *)identifier;


- (UIImage *)loadImageWithName:(NSString *)strName;

- (NSString *)copyToDocumentsDirectory:(NSString *)strName ofType:(NSString *)type;

- (void)initializeDatabase;

- (void)getStories;

- (NSString *)getFilteredString:(NSString *)unfilteredString;

+ (NSString *)getDocumentsDirectory;

@end
