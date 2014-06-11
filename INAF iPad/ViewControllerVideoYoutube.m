//
//  ViewControllerVideoYoutube.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 26/05/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ViewControllerVideoYoutube.h"

@interface ViewControllerVideoYoutube ()
{
    
    
}


@end

@implementation ViewControllerVideoYoutube

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",error.description);
}
- (void)embedYouTube {
    
    float width = 768.0f;
    float height = 704.0f;
   
    self.webView.frame = CGRectMake(60, 60, width, height);
    
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
    [html appendFormat:@"<iframe id=\"ytplayer\" type=\"text/html\" width=\"%0.0f\" height=\"%0.0f\" src=\"http://www.youtube.com/embed/%@\" frameborder=\"0\"/>", width, height, self.video.videoToken];
    [html appendString:@"</body>"];
    [html appendString:@"</html>"];
    
    [self.webView loadHTMLString:html baseURL:nil];
    
    NSLog(@"html %@",self.videoHTML);
    
    
}

- (void)viewDidLoad
{
    self.webView.backgroundColor = [UIColor blackColor];
    self.webView.opaque = NO;
    
   [self embedYouTube];
    
   // [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://youtube.googleapis.com/v/1zTqaJG1IEU%26feature=youtube_gdata"]]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
