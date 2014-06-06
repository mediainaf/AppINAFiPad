//
//  DetailVideoViewController.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 26/05/14.
//  Copyright (c) 2014 Nicolo' Parmiggiani. All rights reserved.
//

#import "DetailVideoViewController.h"
#import "ViewControllerVideoYoutube.h"

@interface DetailVideoViewController ()

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
-(void)viewDidAppear:(BOOL)animated
{
        //self.play.image = [UIImage imageNamed:@"Assets/play.png"];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(apriVideo)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.thumbnailView addGestureRecognizer:singleTap];
    [self.thumbnailView setUserInteractionEnabled:YES];
    
    
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
-(void) apriVideo
{
    ViewControllerVideoYoutube * youtube = [[ViewControllerVideoYoutube alloc] initWithNibName:@"ViewControllerVideoYoutube" bundle:nil];
    
    youtube.video = self.video;
    
  //  [self presentViewController:youtube animated:YES completion:nil];
}
- (void)viewDidLoad
{
    NSLog(@"load");
    
    self.thumbnailView.image=self.thumbnail;
    self.data.text = self.video.data;
    self.numberOfView.text = [NSString stringWithFormat:@"%@ visualizzazioni", self.video.numberOfView];
    self.description.text = self.video.summary;
    [self.description setFont:[UIFont fontWithName:@"Helvetica" size:19.0]];
    
    self.sfondoView.image=[UIImage imageNamed:@"Assets/lab1.jpg"];
    self.sfondoView.alpha = 0.6;
    self.title = self.video.title;
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
