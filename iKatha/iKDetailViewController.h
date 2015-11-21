//
//  iKDetailViewController.h
//  iKatha
//
//  Created by Boove Software on 28/11/13.
//  Copyright (c) 2013 Boove Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "StoryObject.h"

@interface iKDetailViewController : UIViewController <UIGestureRecognizerDelegate,AVAudioPlayerDelegate >

@property(nonatomic) int screenIndx;
@property(nonatomic) int arrayCount;

@property (strong, nonatomic) IBOutlet UIImageView *screenimage;
@property (strong, nonatomic) IBOutlet UILabel *screenlabel;

@property(nonatomic,retain) NSDictionary *storyDictionary;
@property (nonatomic,strong) NSURL *audioUrl;
@property(nonatomic,strong) NSMutableArray *mArray;

@property(nonatomic,strong) AVAudioPlayer *audioPlayer;
@property(strong,nonatomic) NSTimer *Stimer;

@property (strong, nonatomic) IBOutlet UIButton *previousBtn;
@property (strong, nonatomic) IBOutlet UIButton *autoplayBtn;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;

@property (strong, nonatomic) IBOutlet UIGestureRecognizer *swipeGesture;

@property (strong, nonatomic)  UIButton *muteBtn;

@property (strong, nonatomic)  StoryObject *storyObj;


- (IBAction)previousButton:(id)sender;
- (IBAction)autoplayButton:(id)sender;
- (IBAction)nextButton:(id)sender;

//@property(nonatomic,strong) UISwipeGestureRecognizer *swipeGesture;
@property(nonatomic,strong) UITapGestureRecognizer * tapGesture;

//- (IBAction)swipeMethod:(UISwipeGestureRecognizer *)sender;

- (IBAction)handleTapFrom:(UITapGestureRecognizer *)sender;



@end
