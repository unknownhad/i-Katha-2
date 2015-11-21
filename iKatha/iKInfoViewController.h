//
//  iKInfoViewController.h
//  iKatha
//
//  Created by Boove Software on 28/11/13.
//  Copyright (c) 2013 Boove Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iKInfoViewController : UIViewController <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *visitWebsite;
-(IBAction)alertViewBtn:(id)sender;
@end
