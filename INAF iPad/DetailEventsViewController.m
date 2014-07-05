//
//  DetailEventsViewController.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 27/05/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "DetailEventsViewController.h"
#import "NewsInternetViewController.h"

@interface DetailEventsViewController ()
{
    int actionSheetOpen;
    UIActionSheet * action;
}
@end

@implementation DetailEventsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    actionSheetOpen=0;
    
    if(buttonIndex == 0)
    {
        NSString *titolo = self.event.title;
        NSString* spazio = @"";
        NSURL   *imageToShare = [NSURL URLWithString:self.event.link];
        
        NSArray *postItems = [NSArray arrayWithObjects:titolo,spazio,imageToShare, nil];
        
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                                initWithActivityItems:postItems
                                                applicationActivities:nil];
        
        [self presentViewController:activityVC animated:YES completion:nil];
        
    }
    if(buttonIndex == 1)
    {
        NewsInternetViewController * internetViewController = [[NewsInternetViewController alloc] initWithNibName:@"NewsInternetViewController" bundle:nil];
        
        internetViewController.url =self.event.link;
        
        [self.navigationController pushViewController:internetViewController animated:YES];
        
        NSLog(@"Apri link");
    }
}
-(void) action
{
    if(actionSheetOpen==0)
    {
        actionSheetOpen=1;
         action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share",@"Open link", nil];
        [action showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [self deviceOrientationDidChangeNotification:nil];
    
}
- (void)deviceOrientationDidChangeNotification:(NSNotification*)note
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if(orientation == 1 || orientation == 2)
    {
        [self.image setFrame:CGRectMake(10, 187, self.view.frame.size.width-20, 361)];
        
    }
    else
    {
        if(orientation == 3 || orientation == 4)
        {
            
            
            
            [self.image setFrame:CGRectMake(243, 135, 538, 260)];
            
        }
    }
}

- (void)viewDidLoad
{
    int orientation= [UIApplication sharedApplication].statusBarOrientation;
    
    
    
    if(orientation == 1 || orientation == 2)
    {
        [self.image setFrame:CGRectMake(10, 187, self.view.frame.size.width-20, 361)];
        
    }
    else
    {
        if(orientation == 3 || orientation == 4)
        {
            [self.image setFrame:CGRectMake(243, 135, 538, 260)];
            
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

    
    //self.sfondoView.image = [UIImage imageNamed:@"Assets/galileo7.jpg"];
    self.sfondoView.alpha = 0.6;
    
    self.titleEvent.text = self.event.title;
    self.summary.text = self.event.summary;
    
    
    
    
    
    if([self.event.images count] >0)
    {
        NSLog(@"1");
        
        
        [self.image setHidden:NO];
        char const * s = [@"s"  UTF8String];
        
        dispatch_queue_t queue = dispatch_queue_create(s, 0);
        
        dispatch_async(queue, ^
                       {
                           NSString * imageUrl =  [self.event.images objectAtIndex:0] ;
                           
                           NSArray * elements = [ imageUrl componentsSeparatedByString:@"/"];
                           
                           int number = [elements count];
                           
                           NSString * url = [NSString stringWithFormat:@"http://app.media.inaf.it/GetMediaImage.php?sourceYear=%@&sourceMonth=%@&sourceName=%@&width=354&height=201",[elements objectAtIndex:number-3],[elements objectAtIndex:number-2],[elements objectAtIndex:number-1]];
                           
                           NSString *response1 = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
                           if(!response1)
                           {
                               UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Error" message:@"Change internet settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                               [alert show];
                           }
                           
                           NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
                           
                           NSData * response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                           
                           self.image.image = nil;
                           
                           if(response != nil)
                           {
                               
                               NSError * jsonParsingError = nil;
                               
                               NSDictionary * jsonElement = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
                               
                               NSDictionary * json = [jsonElement objectForKey:@"response"];
                               
                               NSString * urlImage = [json objectForKey:@"urlResizedImage"];
                               
                               NSData * dataImmagine = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlImage]];
                               
                               
                               
                               dispatch_async(dispatch_get_main_queue(), ^
                                              {
                                                  NSLog(@"load image");
                                                  
                                                  UIImage * img = [[UIImage alloc] initWithData:dataImmagine];
                                                  
                                                  self.image.image=img;
                                                  
                                              });//end
                           }
                           
                       });//end
        
        
        
        
    }
    else if([self.event.videos count] >0)
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
        [html appendFormat:@"<iframe id=\"ytplayer\" type=\"text/html\" width=\"%0.0f\" height=\"%0.0f\" src=\"%@\" frameborder=\"0\"/>", self.webView.frame.size.width, self.webView.frame.size.height, [self.event.videos objectAtIndex:0]];
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
    
    self.content.text = self.event.content;
    self.author.text = self.event.author;
    self.date.text = self.event.date;

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
