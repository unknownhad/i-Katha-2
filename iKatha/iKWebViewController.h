//
//  iKWebViewController.h
//  iKatha
//
//  Created by Boove Software on 28/11/13.
//  Copyright (c) 2013 Boove Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iKWebViewController : UIViewController <UIWebViewDelegate>

{
    IBOutlet UIWebView *webView;
    IBOutlet UIBarButtonItem *backButton;
    IBOutlet UIBarButtonItem *forwardButton;
    IBOutlet UIBarButtonItem *refreshButton;
    
    
}
@property (nonatomic,retain) IBOutlet UIWebView *webView;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *forwardButton;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *refreshButton;




@end
