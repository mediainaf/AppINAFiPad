//
//  DetailVideoViewController.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 26/05/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "DetailVideoViewController.h"


@interface DetailVideoViewController ()
{
    int actionSheetOpen;
    UIActionSheet * action;
}
@end

@implementation DetailVideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) loadVideo
{
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendString:@"<style type=\"text/css\">"];
    [html appendString:@"body {"];
    [html appendString:@"background-color: transparent;"];
    [html appendString:@"color: white;"];
    [html appendString:@"margin: 0;"];
    [html appendString:@"}"];
    [html appendString:@"</style>"];
    [html appendString:@"</head>"];
    [html appendString:@"<body>"];
    [html appendFormat:@"<iframe id=\"ytplayer\" type=\"text/html\" width=\"%0.0f\" height=\"%0.0f\" src=\"http://www.youtube.com/embed/%@\" frameborder=\"0\"/>", self.webView.frame.size.width, self.webView.frame.size.height, self.video.videoToken];
    [html appendString:@"</body>"];
    [html appendString:@"</html>"];
    
    [self.indicator stopAnimating];
    
    [self.webView loadHTMLString:html baseURL:nil];

}
-(void)viewDidAppear:(BOOL)animated
{
        //self.play.image = [UIImage imageNamed:@"Assets/play.png"];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(apriVideo)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.thumbnailView addGestureRecognizer:singleTap];
    [self.thumbnailView setUserInteractionEnabled:YES];
    
    
    [self loadVideo];
    
    
}
-(void) action
{
   
        
        NSString *titolo = self.video.title;
        NSString* spazio = @" ";
        NSURL   *imageToShare = [NSURL URLWithString:self.video.link];
        UIImage * image = self.thumbnail;
    
        NSArray *postItems = [NSArray arrayWithObjects:titolo,spazio,image,imageToShare, nil];
        
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                                initWithActivityItems:postItems
                                                applicationActivities:nil];
        
        [self presentViewController:activityVC animated:YES completion:nil];
    
}
- (void)deviceOrientationDidChangeNotification:(NSNotification*)note
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if(orientation == 1 || orientation == 2)
    {
        [self.webView setFrame:CGRectMake(10, 32, self.view.frame.size.width-20, 576)];
        [self loadVideo];

    }
    else
    {
        if(orientation == 3 || orientation == 4)
        {
            
          

            [self.webView setFrame:CGRectMake(181, 10, 662, 435)];
            [self loadVideo];

            
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self deviceOrientationDidChangeNotification:nil];
    
}
- (void)viewDidLoad
{
    
    int orientation= [UIApplication sharedApplication].statusBarOrientation;
    
    
    
    if(orientation == 1 || orientation == 2)
    {
        [self.webView setFrame:CGRectMake(10, 32, self.view.frame.size.width-20, 576)];
        [self loadVideo];
    }
    else
    {
        if(orientation == 3 || orientation == 4)
        {
            [self.webView setFrame:CGRectMake(181, 10, 662, 512)];
            [self loadVideo];

        }
    }
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(deviceOrientationDidChangeNotification:)
     name:UIDeviceOrientationDidChangeNotification
     object:nil];
    

    actionSheetOpen=0;
    
    UIBarButtonItem * apriImmagine = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action)];
    
    [self.navigationItem setRightBarButtonItem:apriImmagine animated:YES];

    
    NSLog(@"load");
    
    self.thumbnailView.image=self.thumbnail;
    self.data.text = self.video.data;
    self.numberOfView.text = [NSString stringWithFormat:@"%@ visualizzazioni", self.video.numberOfView];
    self.description.text = self.video.summary;
    [self.description setFont:[UIFont fontWithName:@"Helvetica" size:19.0]];
    
    //self.sfondoView.image=[UIImage imageNamed:@"Assets/lab1.jpg"];
    
    self.sfondoView.image=[UIImage imageNamed:@"Assets/cerisola2.jpg"];
    self.sfondoView.alpha = 0.6;
    self.title = self.video.title;
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [action dismissWithClickedButtonIndex:5 animated:NO];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
