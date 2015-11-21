//
//  iKDetailViewController.m
//  iKatha
//
//  Created by Boove Software on 28/11/13.
//  Copyright (c) 2013 Boove Software. All rights reserved.
//

#import "iKDetailViewController.h"
#import "iKCollectionViewController.h"
#import "iKTitleViewController.h"
#import "iKAppDelegate.h"


@interface iKDetailViewController ()
{
    iKAppDelegate *appDelegate;
}
@property (nonatomic) int maxScreenCount;
//@property (nonatomic) int muteSelected;
@end

@implementation iKDetailViewController

@synthesize nextBtn, previousBtn, audioPlayer, swipeGesture, tapGesture, audioUrl, autoplayBtn, mArray, screenimage, screenlabel, storyDictionary, screenIndx, Stimer, maxScreenCount, arrayCount,muteBtn;


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
    [self drawButton];

	// Do any additional setup after loading the view.
    self.title = self.storyDictionary[@"storyTitle"];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    maxScreenCount = self.storyObj.numOfPages;
    screenIndx = 0;
    //muteSelected = 0;
    
    
    mArray=self.storyDictionary[@"StoryArrayofObjects"];
    
    //screenlabel.text = array[screenIndx][@"Sentence"];
	
    arrayCount= (int) mArray.count;
   
    NSString *strImageName = [self.storyObj.arrImagePaths objectAtIndex:screenIndx];
    //strImageName = @"1.png";
     screenimage.image = [appDelegate loadImageWithName:strImageName];
     screenlabel.text = [self.storyObj.arrSentences objectAtIndex:screenIndx];
    
    //Handling Swipe Gesture
    
    UISwipeGestureRecognizer *rightSwipe=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeMethod:)];
    rightSwipe.direction=UISwipeGestureRecognizerDirectionRight;
     [self.view addGestureRecognizer:rightSwipe];
    
    UISwipeGestureRecognizer *leftSwipe=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeMethod:)];
    leftSwipe.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipe];
    
    //Handling Tap Gesture
    tapGesture = [[UITapGestureRecognizer alloc]
                     initWithTarget:self
                     action:@selector(handleTapFrom:)];
    [self.screenimage addGestureRecognizer:tapGesture];

    tapGesture.delegate = self;
   
    tapGesture.numberOfTapsRequired=1;
    tapGesture.numberOfTouchesRequired=1;
    tapGesture.cancelsTouchesInView=NO;
    [self.view addGestureRecognizer:tapGesture];

    NSString *strAudioFileName =[self.storyObj.strTitle stringByAppendingString:[NSString stringWithFormat:@"%d",screenIndx+1]];
        // Retrieve and play audio file specific to this screen
    NSString *strUrl = [appDelegate.userDefaults valueForKey:strAudioFileName];
    
    strUrl = [[iKAppDelegate getDocumentsDirectory] stringByAppendingPathComponent:strUrl];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    NSError *error;
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@",[error localizedDescription]);
    } else
    {
        audioPlayer.delegate = self;
        if(!muteSelected){
            [audioPlayer play]; }
    }

    
    if((self.screenIndx == 0)){
        [self.previousBtn setHidden:YES];
    }
    
    if (self.storyObj.numOfPages == 1) {
        [self.nextBtn setHidden:YES];
    }
    //[self.btnmute setImage:[UIImage imageNamed:@"iK_btn_mute.png"] forState:UIControlStateNormal];
}

-(void)drawButton
{
	muteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    muteBtn.frame = CGRectMake(935, 61, 45, 45); //set frame for button
	
    if( muteSelected == 1)
    {
		UIImage *buttonImage = [UIImage imageNamed:@"iK_btn_sound.png"];
		[muteBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
    }
    else {
        UIImage *buttonImage = [UIImage imageNamed:@"iK_btn_mute.png"];
        [muteBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
	}

    
	//UIImage *buttonImage = [UIImage imageNamed:@"iK_btn_mute.png"];
	//[muteBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
	
    
	[muteBtn addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
	[self.view addSubview:muteBtn];
}


-(IBAction)previousButton:(id)sender
{
    // previousBtn.enabled=NO;
    
     [self.nextBtn setHidden:NO];
    
    if (screenIndx > 0)
    {
        
        screenIndx--;
        
        if (screenIndx==0)
        {
            [self.previousBtn setHidden:YES];
        }

        NSString *strImageName = [self.storyObj.arrImagePaths objectAtIndex:screenIndx];
        
        screenimage.image = [appDelegate loadImageWithName:strImageName];
        screenlabel.text = [self.storyObj.arrSentences objectAtIndex:screenIndx];

       
        
        
        @try {
//            
//            NSString *strAudioFileName =[self.storyObj.strTitle stringByAppendingString:[NSString stringWithFormat:@"%d",screenIndx+1]];
//            // Retrieve and play audio file specific to this screen
//            NSURL *url = [appDelegate.userDefaults URLForKey:strAudioFileName];
            
            NSString *strAudioFileName =[self.storyObj.strTitle stringByAppendingString:[NSString stringWithFormat:@"%d",screenIndx+1]];
            // Retrieve and play audio file specific to this screen
            NSString *strUrl = [appDelegate.userDefaults valueForKey:strAudioFileName];
            
            strUrl = [[iKAppDelegate getDocumentsDirectory] stringByAppendingPathComponent:strUrl];
            NSURL *url = [NSURL URLWithString:strUrl];
            NSError *error;
            
            
            
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            
            if (error)
            {
                NSLog(@"Error in audioPlayer: %@",[error localizedDescription]);
            } else {
                audioPlayer.delegate = self;
                if(!muteSelected){
                    [audioPlayer play];}
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
       
        
        
        
        
    }
    
}

-(IBAction)nextButton:(id)sender
{
    
    [self.previousBtn setHidden:NO];
    
    if (screenIndx < maxScreenCount)
        
    {
         screenIndx++;
    }
    else
    {
        screenIndx = 0;
    }
    
    
        
        if (self.screenIndx == (self.maxScreenCount - 1))
        {
            [self.nextBtn setHidden:YES];
            
        } else {
            [self.nextBtn setHidden:NO];
        }
        
        NSString *strImageName = [self.storyObj.arrImagePaths objectAtIndex:screenIndx];
    NSLog(@"strimage name %@",strImageName);
        
        screenimage.image = [appDelegate loadImageWithName:strImageName];
        screenlabel.text = [self.storyObj.arrSentences objectAtIndex:screenIndx];
        
    @try {
        
//        // Retrieve and play audio file specific to this screen
//        NSString *strAudioFileName =[self.storyObj.strTitle stringByAppendingString:[NSString stringWithFormat:@"%d",screenIndx+1]];
//        // Retrieve and play audio file specific to this screen
//        NSURL *url = [appDelegate.userDefaults URLForKey:strAudioFileName];
//        NSLog(@"URL IS %@",url);
        
        NSString *strAudioFileName =[self.storyObj.strTitle stringByAppendingString:[NSString stringWithFormat:@"%d",screenIndx+1]];
        // Retrieve and play audio file specific to this screen
        NSString *strUrl = [appDelegate.userDefaults valueForKey:strAudioFileName];
        
        strUrl = [[iKAppDelegate getDocumentsDirectory] stringByAppendingPathComponent:strUrl];
        NSURL *url = [NSURL URLWithString:strUrl];
        
        
        //[self.storyObj.arrAudioPaths objectAtIndex:screenIndx];
        
        NSError *error;
        
        if (audioPlayer) {
            [audioPlayer stop];
            audioPlayer = nil;
        }
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
        if (error){
            NSLog(@"Error in audioPlayer: %@",[error localizedDescription]);
        } else {
            audioPlayer.delegate = self;
            if(!muteSelected){
                [audioPlayer play];}
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
        
    
    
}

- (IBAction)buttonSelected:(id)sender {
    
        
        if( muteBtn.highlighted ==YES &&  muteSelected == 0)
        {
		UIImage *buttonImage = [UIImage imageNamed:@"iK_btn_sound.png"];
		[muteBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
           
            if (audioPlayer) {
                audioPlayer.volume = 0;
            }
            
		muteSelected = 1;
        }
    else {
        UIImage *buttonImage = [UIImage imageNamed:@"iK_btn_mute.png"];
        [muteBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
        muteSelected = 0;
        
        if (audioPlayer) {
            audioPlayer.volume = 0;
        }
	}
    //}

}

-(IBAction)autoplayButton:(id)sender{
    
    
    Stimer= [NSTimer scheduledTimerWithTimeInterval:8.2 target:self selector:@selector(updatePhoto) userInfo:nil repeats:YES];
    [Stimer fire];
    
}

-(void)photoCounter
{
    [ UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.90];
    // [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self cache:NO];
    //self.modalTransitionStyle=UIModalTransitionStylePartialCurl;
    
    [self updatePhoto];
    [UIView commitAnimations];
    
}

-(void) updatePhoto
{
    
    [self.previousBtn setHidden:YES];
    [self.nextBtn setHidden:YES];

    
    if (screenIndx < maxScreenCount){
  
        
        NSString *strImageName = [self.storyObj.arrImagePaths objectAtIndex:screenIndx];
        
        screenimage.image = [appDelegate loadImageWithName:strImageName];
        screenlabel.text = [self.storyObj.arrSentences objectAtIndex:screenIndx];
        
        
        NSString *strAudioFileName =[self.storyObj.strTitle stringByAppendingString:[NSString stringWithFormat:@"%d",screenIndx+1]];
        // Retrieve and play audio file specific to this screen
        NSString *strUrl = [appDelegate.userDefaults valueForKey:strAudioFileName];
        
        strUrl = [[iKAppDelegate getDocumentsDirectory] stringByAppendingPathComponent:strUrl];
        NSURL *url = [NSURL URLWithString:strUrl];
        
        
        NSError *error;
        if (url) {
            
        
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
        if (error){
            NSLog(@"Error in audioPlayer: %@",[error localizedDescription]);
        } else {
            audioPlayer.delegate = self;
            if(!muteSelected){
                [audioPlayer play];}
        }

        }
        screenIndx++;

        
        // (screenIndx > maxScreenCount)? screenIndx=0: screenIndx ++;
        
    }
    else{
    
        NSString *strImageName = [self.storyObj.arrImagePaths objectAtIndex:screenIndx];
        
        screenimage.image = [appDelegate loadImageWithName:strImageName];
        screenlabel.text = [self.storyObj.arrSentences objectAtIndex:screenIndx];
        
        
        // Retrieve and play audio file specific to this screen
        NSURL *url = [self.storyObj.arrAudioPaths objectAtIndex:screenIndx];
        
        NSError *error;
        
        if (url) {
            
        
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
        if (error){
            NSLog(@"Error in audioPlayer: %@",[error localizedDescription]);
        } else {
            audioPlayer.delegate = self;
            if(!muteSelected){
                [audioPlayer play];}
        }
        }
        
        screenIndx=0;
        [Stimer invalidate];
        Stimer = nil;
        [self.previousBtn setHidden:NO];
        
    }
    
}


- (BOOL)ShouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    // Support all orientations.
    //return YES;
    return NO;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    if ([touch.view isKindOfClass:[UIButton class]]){
        return NO;}
    //if (touch.view == self.autoplayBtn)
   // {
      
        return YES;

}

// this enables you to handle multiple recognizers on single view
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

//swipe gesture

-(void)swipeMethod: (UISwipeGestureRecognizer *) sender
{
    
    UISwipeGestureRecognizerDirection direction = [(UISwipeGestureRecognizer *) sender direction];
    
    switch (direction) {
        case UISwipeGestureRecognizerDirectionRight:
            [self previousButton:sender];
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            [self nextButton:sender];
            break;
        default:
            break;
    }
}

- (IBAction)handleTapFrom:(UITapGestureRecognizer *)sender

{
    
   // [audioPlayer stop];
    //[self.previousBtn setHidden:NO];
   // [self.nextBtn setHidden:NO];
    //[Stimer invalidate];
    //Stimer = nil;
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [audioPlayer stop];
    screenIndx=0;
    [Stimer invalidate];
    Stimer = nil;

}
@end
