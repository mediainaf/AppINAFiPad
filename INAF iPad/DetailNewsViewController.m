//
//  DetailNewsViewController.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 28/05/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "DetailNewsViewController.h"

@interface DetailNewsViewController ()

@end

@implementation DetailNewsViewController

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
    
    self.sfondoView.image = [UIImage imageNamed:@"Assets/galileo4.jpg"];
    self.sfondoView.alpha = 0.6;
    
    self.newsTitle.text = self.news.title;
    self.summary.text = self.news.summary;
    
    
    if([self.news.images count] >0)
    {
        NSLog(@"1");

        
        [self.image setHidden:NO];
        char const * s = [@"s"  UTF8String];
        
        dispatch_queue_t queue = dispatch_queue_create(s, 0);
        
        dispatch_async(queue, ^
                       {
                           NSString *url = [self.news.images objectAtIndex:0];
                           
                           UIImage *img = nil;
                           
                           NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
                           
                           img = [[UIImage alloc] initWithData:data];
                           
                           dispatch_async(dispatch_get_main_queue(), ^
                                          {
                                              NSLog(@"load image");
                                              
                                              
                                              //UIImage * image = [self imageWithImage:img];
                                              
                                              self.image.image=img;
                                              
                                          });//end
                       });//end
    }
    else if([self.news.videos count] >0)
    {
        NSLog(@"2");
        
        [self.webView setHidden:NO];
        
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
        [html appendFormat:@"<iframe id=\"ytplayer\" type=\"text/html\" width=\"%0.0f\" height=\"%0.0f\" src=\"%@\" frameborder=\"0\"/>", self.webView.frame.size.width, self.webView.frame.size.height, [self.news.videos objectAtIndex:0]];
        [html appendString:@"</body>"];
        [html appendString:@"</html>"];
        
        //[self.indicator stopAnimating];
        
        [self.webView loadHTMLString:html baseURL:nil];

        
    }
    else
    {
        NSLog(@"3");
        [self.image setHidden:NO];
        self.image.image = [UIImage imageNamed:@"Assets/newsDefault.png"];
        
    }

    self.content.text = self.news.content;
    self.author.text = self.news.author;
    self.date.text = self.news.date;
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
