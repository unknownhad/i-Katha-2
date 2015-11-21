//
//  iKInfoViewController.m
//  iKatha
//
//  Created by Boove Software on 28/11/13.
//  Copyright (c) 2013 Boove Software. All rights reserved.
//

#import "iKInfoViewController.h"
#import "iKWebViewController.h"
#import "iKTitleViewController.h"

#import "iKReachability.h"


@interface iKInfoViewController ()

@property (nonatomic) iKReachability *hostReachability;
@property (nonatomic) iKReachability *internetReachability;
@property (nonatomic) iKReachability *wifiReachability;

@end

@implementation iKInfoViewController
@synthesize visitWebsite;

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
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)alertViewBtn:(id)sender{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Turn off Airplane mode or use Wi-Fi to Access Data" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
        iKReachability *wifiReach = [iKReachability reachabilityForLocalWiFi];
        [wifiReach startNotifier];
    
        NetworkStatus netStatus2 = [wifiReach currentReachabilityStatus];
    
    if(netStatus2 == NotReachable)
    {
        [alert show];    }
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"VisitourWebsite"])
	{
        iKWebViewController *ikinfovc = segue.destinationViewController;
        ikinfovc.title=@"Visit Prayas Website";
		
	}
    
}

@end
