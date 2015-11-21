//
//  iKAddEditStoryController.m
//  iKatha
//
//  Created by M on 02/08/15.
//  Copyright (c) 2015 Boove Software. All rights reserved.
//

#import "iKAddEditStoryController.h"
#import "StoryObject.h"
#import "iKCollectionViewController.h"

#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_. "

@interface iKAddEditStoryController ()
{
    iKAppDelegate *appDelegate;
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    UIImagePickerController *picker;
    NSString *title;
    int currentPage;
    BOOL isRecording;
    BOOL isEditMode;
    
    
    
}

@end

@implementation iKAddEditStoryController

- (void)viewDidLoad {
    [super viewDidLoad];

    appDelegate = (iKAppDelegate *)[[UIApplication sharedApplication]delegate];

    // Do any additional setup after loading the view.
    self.txtViewSentence.layer.cornerRadius = 5.0;
    self.txtViewSentence.layer.borderWidth = 1.0;
    self.txtViewSentence.layer.borderColor = [UIColor lightGrayColor].CGColor;
    currentPage = 1;
    //title = @"testtitle";
    
    if (!self.storyObject) {
        
        self.storyObject = [StoryObject new];
        self.storyObject.arrSentences = [NSMutableArray new];
        self.storyObject.arrAudioPaths = [NSMutableArray new];
        self.storyObject.arrImagePaths = [NSMutableArray new];
    }
    else
    {
        self.txtFieldTitle.userInteractionEnabled = NO;
        if (self.storyObject.numOfPages == 1) {
            self.btnBack.hidden = YES;
            self.btnNext.hidden = YES;
        }
        isEditMode = YES;
        self.txtFieldTitle.text = self.storyObject.strTitle;
        self.txtViewSentence.text = [self.storyObject.arrSentences objectAtIndex:0];
        
        NSString *strImgName = [self.storyObject.arrImagePaths objectAtIndex:0];
        self.imgView.image = [appDelegate loadImageWithName:strImgName];
    }
    
    
    
    appDelegate.isAdding = YES;
    [appDelegate initializeDatabase];
    appDelegate.fmdatabase = [FMDatabase databaseWithPath:appDelegate.strDBPath];
    [appDelegate.fmdatabase open];
    [appDelegate.audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    [appDelegate.audioSession setActive:YES error:nil];
    
    [recorder setDelegate:self];
    
    
    
    
    [super viewDidLoad];
}


- (void)viewDidAppear:(BOOL)animated
{
    picker = [[UIImagePickerController alloc]init];
   //[self SelectPhotoFromLibrary];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
}

-(void)btnPhotoSelection
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Camera",@"Select Photo From Library", @"Cancel", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
   // actionSheet.destructiveButtonIndex = 1;
    [actionSheet showInView:self.view];
   
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
    if (buttonIndex == 0)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            // NSLog(@"parameter1: %d parameter2: %f", parameter1, parameter2);
            [self TakePhotoWithCamera];
        });
        
    }
    else if (buttonIndex == 1)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
          // NSLog(@"parameter1: %d parameter2: %f", parameter1, parameter2);
            [self SelectPhotoFromLibrary];
        });
        
    }
    
    else if (buttonIndex == 2)
    {
        NSLog(@"cancel");
    }
}

-(void) TakePhotoWithCamera
{
    picker.delegate = self;
    picker.allowsEditing = YES;

    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
  //  UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    //self.popover = [[UIPopoverController alloc] initWithContentViewController: picker];
    //self.popover.delegate =self;
    //[self.popover presentPopoverFromRect:self.view.bounds inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    [self presentViewController:picker animated:YES completion:nil];
}

-(void) SelectPhotoFromLibrary
{
    
    
//    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
//        [self presentViewController:picker animated:YES completion:nil];
//    else
//    {
//        self.popover=[[UIPopoverController alloc]initWithContentViewController:picker];
//        
//        [self.popover presentPopoverFromRect:self.btnTitlePic.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//        self.popover.delegate = self;
//    }
    
    picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
     [self presentModalViewController:picker animated:YES];
    
    return;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if(!self.popover)
        {
            self.popover = [[UIPopoverController alloc] initWithContentViewController:picker];
        }
        
//        [self.popover presentPopoverFromRect:CGRectMake(500, 620, 0, 0)
//                                 inView:self.view
//               permittedArrowDirections:UIPopoverArrowDirectionUp
//                               animated:YES];
        
        [self.view addSubview:picker.view];
    }
    else
    {
        [self presentModalViewController:picker animated:YES];
    }

}
    
    


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)pickerL
{
    [pickerL dismissViewControllerAnimated:YES completion:nil];
}



- (void)imagePickerController:(UIImagePickerController *)pickerL didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * img = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.imgView.backgroundColor = [UIColor clearColor];
    self.imgView.image = img;
    
    NSString *strName = [self.txtFieldTitle.text stringByAppendingString:[NSString stringWithFormat:@"%d",currentPage]];
    
    strName = [strName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    strName = [strName stringByAppendingString:@".png"];
    
    
    @try {
        
        [self.storyObject.arrImagePaths setObject:[self saveImage:strName] atIndexedSubscript:currentPage-1];
        
    }
    @catch (NSException *exception) {
        [self.storyObject.arrImagePaths addObject:strName];

        
    }
    @finally {

    }
    
    
    [pickerL dismissModalViewControllerAnimated:NO];
}


- (IBAction)actionShowActionSheet:(id)sender
{
   // [self SelectPhotoFromLibrary];
    
    [self btnPhotoSelection];
    

}


- (IBAction)actionRecord:(id)sender
{
    [self record];
}

- (IBAction)actionPlay:(id)sender
{
    [self playBack];
}


- (IBAction)actionBackStep:(id)sender
{
    if (currentPage > 1) {
        
        self.btnNext.hidden = NO;
        
        currentPage = currentPage - 1;
        if (currentPage == 1) {
            
            self.btnBack.hidden = YES;
        }
        self.txtViewSentence.text = [self.storyObject.arrSentences objectAtIndex:currentPage-1];
        
        NSString *strImgName = [self.storyObject.arrImagePaths objectAtIndex:currentPage-1];
        self.imgView.image = [appDelegate loadImageWithName:strImgName];
    }
    
    
}



- (IBAction)actionNextFinish:(id)sender
{
    
//    if (isEditMode) {
//        
//        self.txtViewSentence.text = [self.storyObject.arrSentences objectAtIndex:currentPage-1];
//        
//        NSString *strImgName = [self.storyObject.arrImagePaths objectAtIndex:currentPage-1];
//        self.imgView.image = [appDelegate loadImageWithName:strImgName];
//        
//
//        
//    }
//    
    
    
    if (self.txtFieldTitle.text.length == 0) {
        
        [iKAppDelegate showAlertDialog:@"Please enter story title"];
        return;
    }
    
    if (self.txtViewSentence.text.length == 0) {
        
        [iKAppDelegate showAlertDialog:@"Please enter story line/sentence"];\
        return;
    }
    
    if (self.imgView.image == nil) {
        [iKAppDelegate showAlertDialog:@"Please choose an image."];
        return;
    }
    
    self.txtFieldTitle.userInteractionEnabled = NO;
     self.storyObject.strTitle = self.txtFieldTitle.text;
    @try {
        
        [self.storyObject.arrSentences setObject:self.txtViewSentence.text atIndexedSubscript:currentPage-1];
        
    }
    @catch (NSException *exception) {
        
        
        [self.storyObject.arrSentences addObject:self.txtViewSentence.text];
        
        
        
    }
    @finally {
        
    }

    
    if ([sender tag] == 4) {
        
        
        currentPage = currentPage + 1;
        
        if (isEditMode) {
            
        
        if (currentPage > self.storyObject.arrSentences.count) {
            
            currentPage--;
            self.btnNext.hidden = YES;
        }
        else
        {
            self.btnNext.hidden = NO;
        }
        }
        self.btnBack.hidden = NO;
        if (currentPage <= self.storyObject.arrSentences.count ) {
            self.txtViewSentence.text = [self.storyObject.arrSentences objectAtIndex:currentPage-1];
            
            NSString *strImgName = [self.storyObject.arrImagePaths objectAtIndex:currentPage-1];
            self.imgView.image = [appDelegate loadImageWithName:strImgName];
        }
        
        else
        {
            self.txtViewSentence.text = @"";
            self.imgView.image = nil;
            self.imgView.backgroundColor = [UIColor blackColor];
        }
        
        
    }
    else
    {
        @try {
            
            [self.storyObject.arrAudioPaths objectAtIndex:currentPage - 1];
        }
        @catch (NSException *exception) {
            
            [self.storyObject.arrAudioPaths addObject:@""];
            
        }
        @finally {
            
        }
        
        NSString *audioPath = [self.storyObject.arrAudioPaths componentsJoinedByString:@"|"];
        
        NSString *imgPath = [self.storyObject.arrImagePaths componentsJoinedByString:@"|"];
        
        NSString *sentences = [self.storyObject.arrSentences componentsJoinedByString:@"|"];
        
        BOOL success;
        if (isEditMode) {
            
            
            success = [appDelegate.fmdatabase executeUpdate:@"UPDATE story_master SET title = ?,story_text = ?,story_img_path = ?,audio_path = ?,num_of_pages = ? WHERE id = ?",self.storyObject.strTitle,sentences,imgPath,audioPath,[NSNumber numberWithInteger:self.storyObject.arrSentences.count],[NSNumber numberWithInteger:self.storyObject.storyId]];
        }
        else
        {
            success =  [appDelegate.fmdatabase executeUpdate:@"insert into story_master(title,story_text,story_img_path,audio_path,num_of_pages) values (?, ?, ?, ?, ?)",self.storyObject.strTitle,sentences,imgPath,audioPath,[NSNumber numberWithInteger:self.storyObject.arrSentences.count],[NSNumber numberWithInteger:self.storyObject.storyId]];
        }
        
        if (success) {
            
            
            iKCollectionViewController *controller = (iKCollectionViewController *)[iKAppDelegate getViewControllerFromStoryboard:@"iKCollectionViewController"];
            [self.navigationController popToViewController:appDelegate.collectionController animated:YES];
        }
        NSLog(@"Success is %d",success);
    }
        
    
    
}

- (IBAction) record
{
    if (self.txtFieldTitle.text.length == 0) {
        
        [iKAppDelegate showAlertDialog:@"Please enter a story title before recording."];
        return;
    }
    if (isRecording) {
        
        

        self.btnPlay.userInteractionEnabled = YES;
        [self.btnRecord setTitle:@"RECORD" forState:UIControlStateNormal];
        self.lblRecordingStatus.text = @"";
        isRecording = NO;
        [recorder stop];
        return;
    }
    self.btnPlay.userInteractionEnabled = NO;
    [self.btnRecord setTitle:@"STOP" forState:UIControlStateNormal];
    self.lblRecordingStatus.text = @"Recording...";
    isRecording = YES;
    NSError *error;
    
    // Recording settings
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    
    [settings setValue: [NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [settings setValue: [NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
    [settings setValue: [NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    [settings setValue: [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    [settings setValue:  [NSNumber numberWithInt: AVAudioQualityMedium] forKey:AVEncoderAudioQualityKey];
    
    NSArray *searchPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath_ = [searchPaths objectAtIndex: 0];
    
    title = [self.txtFieldTitle.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *strAudioFileName =[title stringByAppendingString:[NSString stringWithFormat:@"%d",currentPage]];
    
    NSString *pathToSave = [documentPath_ stringByAppendingPathComponent:strAudioFileName];
    
    pathToSave = [pathToSave stringByAppendingString:@".aif"];
    // File URL
    NSURL *url = [NSURL fileURLWithPath:pathToSave];//FILEPATH];
    
    
    @try {
        
        [self.storyObject.arrAudioPaths setObject:[strAudioFileName stringByAppendingString:@".aif"] atIndexedSubscript:currentPage - 1];
    }
    @catch (NSException *exception) {
        
        [self.storyObject.arrAudioPaths addObject:[strAudioFileName stringByAppendingString:@".aif"]];
        
    }
    @finally {
        
    }
   
    
   
    
    //Save recording path to preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
   // [appDelegate.audioSession setm]
        [prefs setValue:[strAudioFileName stringByAppendingString:@".aif"] forKey:[self.txtFieldTitle.text stringByAppendingString:[NSString stringWithFormat:@"%d",currentPage]]];
    [prefs synchronize];
    
    NSLog(@"url is %@",url);
    
    NSLog(@"pref value is %@",[strAudioFileName stringByAppendingString:@".aif"]);
    NSLog(@"pref key is %@",[self.txtFieldTitle.text stringByAppendingString:[NSString stringWithFormat:@"%d",currentPage]]);
    

    
    // Create recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
    
    [recorder prepareToRecord];
    
    [recorder record];
}

-(IBAction)playBack
{
    if (!self.btnRecord.userInteractionEnabled) {
        
        return;
    }
    self.btnRecord.userInteractionEnabled = NO;
    self.lblRecordingStatus.text = @"Playing...";
    [self.btnPlay setTitle:@"STOP" forState:UIControlStateNormal];

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [audioSession setActive:YES error:nil];
    
    
    //Load recording path from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *strAudioFileName =[self.txtFieldTitle.text stringByAppendingString:[NSString stringWithFormat:@"%d",currentPage]];
    NSString *teststring = [prefs valueForKey:strAudioFileName];
    strAudioFileName = [strAudioFileName stringByAppendingString:@".aif"];
  // NSString *teststring = [prefs valueForKey:strAudioFileName];
    NSURL *temporaryRecFile = [NSURL URLWithString:[[iKAppDelegate getDocumentsDirectory] stringByAppendingPathComponent:teststring]];
    NSLog(@"playback url  is %@",temporaryRecFile);
    
    if (player) {
        
        [player stop];
        player = nil;
    }
    NSError *error;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:temporaryRecFile error:&error];
    
    NSLog(@"error description %@",error.description);
    
    
    player.delegate = self;
    
    
    [player setNumberOfLoops:0];
    player.volume = 1;
    
    
    [player prepareToPlay];
    
    [player play];
    
    
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.lblRecordingStatus.text = @"";
    self.btnRecord.userInteractionEnabled = YES;
    [self.btnPlay setTitle:@"PLAY" forState:UIControlStateNormal];
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    self.lblRecordingStatus.text = error.description;
    self.btnRecord.userInteractionEnabled = YES;
    [self.btnPlay setTitle:@"PLAY" forState:UIControlStateNormal];

}

- (NSString *)saveImage:(NSString *)imgName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:imgName];
    
    NSData *imageData = UIImagePNGRepresentation(self.imgView.image);
    [imageData writeToFile:savedImagePath atomically:NO];
    
    return imgName;
}

- (NSString *)getImage:(NSString *)imgName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:imgName];
    
    NSData *imageData = UIImagePNGRepresentation(self.imgView.image);
    [imageData writeToFile:savedImagePath atomically:NO];
    
    return savedImagePath;
}



- (void)showData
{
    
    self.txtFieldTitle.text = self.storyObject.strTitle;
    self.txtViewSentence.text = [self.storyObject.arrSentences objectAtIndex:currentPage-1];
    NSString *strImageName = [self.storyObject.strTitle stringByAppendingString:[NSString stringWithFormat:@"%d",currentPage]];
    strImageName = [strImageName stringByAppendingString:@".png"];
    self.imgView.image = [appDelegate loadImageWithName:strImageName];
}

- (IBAction)actionChoosePhoto:(id)sender
{
    
    self.viewSheet.hidden = YES;
    
    int tag = (int)[sender tag];
    
    if (tag == 9) {
        
        [self TakePhotoWithCamera];
    }
    else if(tag == 10)
    {
        [self SelectPhotoFromLibrary];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (NSUInteger)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskLandscape;
//}

- (void)viewWillDisappear:(BOOL)animated
{
    appDelegate.isAdding = NO;
}


@end
