//
//  iKWebViewController.m
//  iKatha
//
//  Created by Boove Software on 28/11/13.
//  Copyright (c) 2013 Boove Software. All rights reserved.
//

#import "iKWebViewController.h"
#import "iKInfoViewController.h"

@interface iKWebViewController ()

@end

@implementation iKWebViewController
@synthesize backButton,forwardButton,refreshButton,webView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(IBAction)goback:(id)sender
{
    [webView goBack];
}
-(IBAction)goforward:(id)sender
{
    [webView goForward];
}
-(IBAction)refresh:(id)sender
{
    [webView reload];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSURL *url=[NSURL URLWithString:@"http://learn4autism.com/about-prayas.html"];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"NavigationBackButton"])
	{
		iKInfoViewController *ikinfovc = segue.destinationViewController;
		ikinfovc.title=@"Visit our website";
	}
    
}
@end
