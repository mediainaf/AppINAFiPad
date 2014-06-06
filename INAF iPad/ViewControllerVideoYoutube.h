//
//  ViewControllerVideoYoutube.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 26/05/14.
//  Copyright (c) 2014 Nicolo' Parmiggiani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Video.h"

@interface ViewControllerVideoYoutube : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)close:(id)sender;
@property(nonatomic, retain) NSString *videoURL;
@property(nonatomic, retain) NSString *videoHTML;
@property (nonatomic,strong) Video * video;

@end
