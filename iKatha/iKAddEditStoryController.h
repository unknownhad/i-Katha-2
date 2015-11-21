//
//  iKAddEditStoryController.h
//  iKatha
//
//  Created by M on 02/08/15.
//  Copyright (c) 2015 Boove Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iKAppDelegate.h"
#import "StoryObject.h"
@interface iKAddEditStoryController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,AVAudioPlayerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewSheet;

@property(strong,nonatomic)UIPopoverController *popover;

@property(weak,nonatomic)IBOutlet UIImageView *imgView;

@property(weak,nonatomic)IBOutlet UITextView *txtViewSentence;

@property(weak,nonatomic)IBOutlet UITextField *txtFieldTitle;

@property(weak,nonatomic)IBOutlet UIButton *btnRecord;

@property(weak,nonatomic)IBOutlet UIButton *btnPlay;

@property(weak,nonatomic)IBOutlet UILabel *lblRecordingStatus;

@property (weak, nonatomic) IBOutlet UIButton *btnTitlePic;

@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (weak, nonatomic) IBOutlet UIButton *btnBack;


@property(strong,nonatomic) StoryObject *storyObject;



- (IBAction)actionRecord:(id)sender;

- (IBAction)actionPlay:(id)sender;

- (IBAction)actionShowActionSheet:(id)sender;

- (IBAction)actionNextFinish:(id)sender;

- (IBAction)actionBackStep:(id)sender;

- (IBAction)actionChoosePhoto:(id)sender;











@end
