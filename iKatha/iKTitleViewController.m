//
//  iKTitleViewController.m
//  iKatha
//
//  Created by Boove Software on 28/11/13.
//  Copyright (c) 2013 Boove Software. All rights reserved.
//

#import "iKTitleViewController.h"
#import "iKCollectionViewController.h"
#import "iKAppDelegate.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "StoryObject.h"


@interface iKTitleViewController ()
{
    iKAppDelegate *appDelegate;
}

@end

@implementation iKTitleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
     self.title=@"Social Stories";
    appDelegate = (iKAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        
        
        [appDelegate initializeDatabase];
         appDelegate.fmdatabase = [FMDatabase databaseWithPath:appDelegate.strDBPath];
        [appDelegate.fmdatabase open];
        
        
        
        FMResultSet *results = [appDelegate.fmdatabase executeQuery:@"SELECT * FROM story_master"];
        while([results next]) {
            
            StoryObject *object = [StoryObject new];
            
             int strId = [results intForColumn:@"id"];
            NSString *strTitle = [NSString stringWithFormat:@"%@",[results stringForColumn:@"title"]];
            strTitle = [appDelegate getFilteredString:strTitle];
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
            
            for (int j=0; j<object.arrAudioPaths.count; j++) {
                
                NSString *str = [object.arrAudioPaths objectAtIndex:j];
                str = [str stringByAppendingString:@".mp3"];
                [object.arrAudioPaths replaceObjectAtIndex:j withObject:[@"" stringByAppendingPathComponent:str]];
            }
            
            
            
             object.arrImagePaths = [[object.strImagePath componentsSeparatedByString:@"|"] mutableCopy];
            object.arrSentences = [[object.strText componentsSeparatedByString:@"|"] mutableCopy];
            
            [appDelegate.storiesArray addObject:object];
            
            
            NSLog(@"story title %@",strTitle);
        }

        
        if ([appDelegate.userDefaults valueForKey:@"isCreated"]) {
            
            NSLog(@"returned");

            return ;
        }

        StoryObject *storyObj1 = [appDelegate.storiesArray objectAtIndex:0];
        
        for (int i=0; i<storyObj1.arrSentences.count; i++) {
            
            NSString *strImgName = [storyObj1.arrImagePaths objectAtIndex:i];
            NSString *strAudioName = [storyObj1.arrAudioPaths objectAtIndex:i];
            [appDelegate copyToDocumentsDirectory:strImgName ofType:@".png"];
            
            [appDelegate copyToDocumentsDirectory:strAudioName ofType:@".mp3"];
            
           // strPath = [strPath stringByAppendingString:@".mp3"];
            
            
            
            [appDelegate.userDefaults setObject:strAudioName forKey:[storyObj1.strTitle stringByAppendingString:[NSString stringWithFormat:@"%d",i+1]]];
            [appDelegate.userDefaults synchronize];

            
        }
        
        StoryObject *storyObj2 = [appDelegate.storiesArray objectAtIndex:1];
        
        for (int i=0; i<storyObj2.arrSentences.count; i++) {
            
            NSString *strImgName = [storyObj2.arrImagePaths objectAtIndex:i];
            NSString *strAudioName = [storyObj2.arrAudioPaths objectAtIndex:i];
            [appDelegate copyToDocumentsDirectory:strImgName ofType:@".png"];
          [appDelegate copyToDocumentsDirectory:strAudioName ofType:@".mp3"];
            
            
            // strPath = [strPath stringByAppendingString:@".mp3"];
                [appDelegate.userDefaults setObject:strAudioName forKey:[storyObj2.strTitle stringByAppendingString:[NSString stringWithFormat:@"%d",i+1]]];
                [appDelegate.userDefaults synchronize];
            

            
        }

        [appDelegate.userDefaults setValue:@"Y" forKey:@"isCreated"];
        [appDelegate.userDefaults synchronize];

        dispatch_async(dispatch_get_main_queue(), ^{ // 2
            
            
            
            
        });
    });
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ReadStories"])
	{
        iKCollectionViewController *ikcvc = segue.destinationViewController;
        
        appDelegate.collectionController = ikcvc;
        ikcvc.title =@"Social Stories";
        
	}
    else
    {
        iKCollectionViewController *ikcvc = segue.destinationViewController;
        
        appDelegate.collectionController = ikcvc;
        appDelegate.isAdding = YES;
    }
    
    
}


@end
