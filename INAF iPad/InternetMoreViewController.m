//
//  InternetMoreViewController.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 13/06/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


#import "InternetMoreViewController.h"

@interface InternetMoreViewController ()

@end

@implementation InternetMoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.indicator stopAnimating];
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    
    NSLog(@"%@", error.description);
    
    if(error.code!=-999)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Internet connection failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        
        [alert show];
        
        [self.indicator stopAnimating];
    }
}
- (void)viewDidLoad
{
    
    [self.indicator startAnimating];
    
    NSLog(@"%@",self.url);
    
    //self.url = @"http://www.media.inaf.it/2014/06/12/oceani-terrestri-sotterreanei/";
    

    NSURL * urlNews = [NSURL URLWithString:self.url ];
    
    NSURLRequest * newsUrlRequest = [NSURLRequest requestWithURL:urlNews];
    
    [self.webView loadRequest:newsUrlRequest];
    
    self.webView.scalesPageToFit=YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
