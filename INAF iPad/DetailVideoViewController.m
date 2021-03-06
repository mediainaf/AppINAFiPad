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
    [html appendFormat:@"<iframe id=\"ytplayer\"  width=\"%0.0f\" height=\"%0.0f\" src=\"http://www.youtube.com/embed/%@\" frameborder=\"0\"/>", self.webView.frame.size.width, self.webView.frame.size.height, self.video.videoToken];
    [html appendString:@"</body>"];
    [html appendString:@"</html>"];
    
    [self.indicator stopAnimating];
    
    [self.webView loadHTMLString:html baseURL:nil];

}
-(void)viewDidAppear:(BOOL)animated
{
     [self deviceOrientationDidChangeNotification:nil];
        //self.play.image = [UIImage imageNamed:@"Assets/play.png"];
    
    [self calcolaScroll];
    
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
    
    UIDevice * device = [UIDevice currentDevice];
    
    if([device.systemVersion hasPrefix:@"8"])
    {
        
        UIPopoverPresentationController *presentationController =
        [activityVC popoverPresentationController];
        
        presentationController.sourceView = self.navigationController.navigationBar;
    }

    
}
-(CGSize) getContentSize:(UITextView*) myTextView{
    return [myTextView sizeThatFits:CGSizeMake(myTextView.frame.size.width, FLT_MAX)];
}
-(void) calcolaScroll
{
    CGRect rect      = self.descriptionText.frame;
    rect.size.height = [self getContentSize:self.descriptionText].height;
    self.descriptionText.frame   = rect;
    
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.descriptionText.frame.origin.y+self.descriptionText.frame.size.height+50)];
    
    
    rect = self.data.frame;
    rect.origin.y = self.descriptionText.frame.origin.y+20+self.descriptionText.frame.size.height ;
   
    if(rect.origin.y > 892)
        self.data.frame = rect;
    
    rect = self.numberOfView.frame;
    
    rect.origin.y = self.descriptionText.frame.origin.y+20+self.descriptionText.frame.size.height ;
    if(rect.origin.y > 892)
        self.numberOfView.frame = rect;
    
    /*
     CGRect rect      = self.content.frame;
     rect.size.height = self.content.contentSize.height;
     self.content.frame   = rect;
     
     [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.content.frame.origin.y+self.content.frame.size.height+50)];
     
     rect = self.date.frame;
     rect.origin.y = self.content.frame.origin.y+20+self.content.frame.size.height ;
     self.date.frame = rect;
     
     rect = self.author.frame;
     rect.origin.y = self.content.frame.origin.y+20+self.content.frame.size.height ;
     self.author.frame = rect;
     */
}
/*
 -(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    [self calcolaScroll];

    NSLog(@"webview %f",self.webView.frame.origin.x);
    
    if(fromInterfaceOrientation == 3 || fromInterfaceOrientation == 4)
    {
        [self.webView setFrame:CGRectMake(10, 32,748, 576)];
        [self loadVideo];
        
    }
    else
    {
        if(fromInterfaceOrientation == 1 || fromInterfaceOrientation == 2)
        {
            
            
            
            [self.webView setFrame:CGRectMake(181, 10, 662, 435)];
            [self loadVideo];
            
            
        }
    }

}*/
- (void)deviceOrientationDidChangeNotification:(NSNotification*)note
{
    
    [self calcolaScroll];

    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if(orientation == 1 || orientation == 2)
    {
        NSLog(@"portrait");
        
        [self.webView setFrame:CGRectMake(10, 32, 748, 576)];
        [self loadVideo];

    }
    else
    {
        if(orientation == 3 || orientation == 4)
        {
            
            NSLog(@"landscape");

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
        [self.webView setFrame:CGRectMake(10, 32, 748 , 576)];
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
    self.descriptionText.text = self.video.summary;
    [self.descriptionText setFont:[UIFont fontWithName:@"Helvetica" size:19.0]];
    
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
