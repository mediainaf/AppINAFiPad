//
//  DetailNewsViewController.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 28/05/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "DetailNewsViewController.h"
#import "NewsInternetViewController.h"
#import "ImmagineGrandeViewController.h"

@interface DetailNewsViewController ()
{
    int actionSheetOpen;
    UIActionSheet * action;
}
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
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    actionSheetOpen = 0;
    
    
    if(buttonIndex == 0)
    {
        
         NSString *titolo = self.news.title;
         NSString* spazio = @"";
         
         
         UIImage * image = self.image.image;
         
         NSArray *postItems;
         
         if(image)
         
         postItems  = [NSArray arrayWithObjects:titolo,spazio,self.news.link,image, nil];
         
         else
         postItems  = [NSArray arrayWithObjects:titolo,spazio,self.news.link, nil];
         
         
         
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
        
        
        /*
        NSString *titolo = self.news.title;
        NSString* spazio = @"";
        
        
        UIImage * image = self.image.image;
        
        NSArray *postItems;
        
        if(image)
            
            postItems  = [NSArray arrayWithObjects:titolo,spazio,self.news.link,image, nil];
        
        else
            postItems  = [NSArray arrayWithObjects:titolo,spazio,self.news.link, nil];
        
        
        
        UIActivityViewController *controller =
        [[UIActivityViewController alloc]
         initWithActivityItems:postItems
         applicationActivities:nil];
        
        [self presentViewController:controller animated:YES completion:nil];
        
        UIPopoverPresentationController *presentationController =
        [controller popoverPresentationController];
        
        presentationController.sourceView = self.view;
        */
        
    }
    if(buttonIndex == 1)
        
    {
        NewsInternetViewController * internetViewController = [[NewsInternetViewController alloc] initWithNibName:@"NewsInternetViewController" bundle:nil];
        
        NSArray * elements = [ self.news.link componentsSeparatedByString:@"/"];
        
        NSMutableArray * elementsArray = [[NSMutableArray alloc] init ];
        
        [elementsArray setArray:elements];
        
        [elementsArray removeLastObject];
        
        NSMutableString * link = [[NSMutableString alloc] initWithString:[elementsArray componentsJoinedByString:@"/"]];
        
        
        
        
        internetViewController.url =link;
        NSLog(@"Apri link %@",self.news.link);
        
        
        [self.navigationController pushViewController:internetViewController animated:YES];
        
    }
    if(buttonIndex == 2)
    {
        
        ImmagineGrandeViewController * viewControllerImmagineGrande = [[ImmagineGrandeViewController alloc]initWithNibName:@"ImmagineGrandeViewController" bundle:nil];
        
        viewControllerImmagineGrande.imageUrl= [self.news.images objectAtIndex:0];
        
        [self.navigationController pushViewController:viewControllerImmagineGrande animated:YES];

    }

}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
}
-(void) action
{
    
    if(actionSheetOpen == 0)
    {
        actionSheetOpen = 1;
        
         action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share",@"Open link",@"Open Image", nil];
        
       
        
        
        action.actionSheetStyle =UIActionSheetStyleBlackOpaque ;
        
        [action showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    }
   

    


}
-(CGSize) getContentSize:(UITextView*) myTextView{
    return [myTextView sizeThatFits:CGSizeMake(myTextView.frame.size.width, FLT_MAX)];
}
-(void) calcolaScroll
{
    CGRect rect      = self.content.frame;
    rect.size.height = [self getContentSize:self.content].height;
    self.content.frame   = rect;
    
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.content.frame.origin.y+self.content.frame.size.height+50)];
    
    
    rect = self.date.frame;
    rect.origin.y = self.content.frame.origin.y+20+self.content.frame.size.height ;
    self.date.frame = rect;
    
    rect = self.author.frame;
    
    rect.origin.y = self.content.frame.origin.y+20+self.content.frame.size.height ;
    self.author.frame = rect;

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
    self.author.frame = rect;*/

}
-(void)viewDidAppear:(BOOL)animated
{
    
    float textHeight = self.content.contentSize.height;
    NSLog(@" altezza %f",textHeight);
    
    [self calcolaScroll];
    [self deviceOrientationDidChangeNotification:nil];

    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self deviceOrientationDidChangeNotification:nil];

}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self calcolaScroll];
    
    if(fromInterfaceOrientation == 3 || fromInterfaceOrientation == 4)
    {
        [self.image setFrame:CGRectMake(10, 187, self.view.frame.size.width-20, 361)];
        
        if([self.news.videos count] >0)
        {
            
           [self.webView setFrame:CGRectMake(10, 187, self.view.frame.size.width-20, 361)];
            
            [self loadVideo];
        }
        
        
    }
    else
    {
        if(fromInterfaceOrientation == 1 || fromInterfaceOrientation == 2)
        {
            
            
            [self.image setFrame:CGRectMake(243, 135, 538, 260)];
            if([self.news.videos count] >0)
            {
                
                [self.webView setFrame:CGRectMake(243, 135, 538, 260)];
                
                [self loadVideo];
            }
            
            
        }
    }
    
    
}
- (void)deviceOrientationDidChangeNotification:(NSNotification*)note
{
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.content.frame.origin.y+self.content.frame.size.height+50)];

    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if(orientation == 1 || orientation == 2)
    {
        [self.image setFrame:CGRectMake(10, 187, self.view.frame.size.width-20, 361)];
        [self.webView setFrame:CGRectMake(10, 187, self.view.frame.size.width-20, 361)];
        
    }
    else
    {
        if(orientation == 3 || orientation == 4)
        {
            
            
            
            [self.image setFrame:CGRectMake(243, 135, 538, 260)];
            if([self.news.videos count] >0)
            {
                
                [self.webView setFrame:CGRectMake(243, 135, 538, 260)];
                
                [self loadVideo];
            }
        }
    }
}
-(void) loadVideo
{
    
    
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
- (void)viewDidLoad
{
    
    int orientation= [UIApplication sharedApplication].statusBarOrientation;
    
    
    
    if(orientation == 1 || orientation == 2)
    {
        [self.image setFrame:CGRectMake(10, 187, self.view.frame.size.width-20, 361)];
        if([self.news.videos count] >0)
        {
            
            [self.webView setFrame:CGRectMake(10, 187, self.view.frame.size.width-20, 361)];
            
            [self loadVideo];
        }
        
        
    }
    else
    {
        if(orientation == 3 || orientation == 4)
        {
            
            
            
            [self.image setFrame:CGRectMake(243, 135, 538, 260)];
            if([self.news.videos count] >0)
            {
                
                [self.webView setFrame:CGRectMake(243, 135, 538, 260)];
                
                [self loadVideo];
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(deviceOrientationDidChangeNotification:)
     name:UIDeviceOrientationDidChangeNotification
     object:nil];
    
    actionSheetOpen = 0;
    
    UIBarButtonItem * apriImmagine = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action)];
    
    [self.navigationItem setRightBarButtonItem:apriImmagine animated:YES];
    
    self.sfondoView.image = [UIImage imageNamed:@"Assets/galileo7.jpg"];
    //self.sfondoView.image = [UIImage imageNamed:@"Assets/galileo4.jpg"];
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
                           NSString * imageUrl =  [self.news.images objectAtIndex:0] ;
                           
                           NSArray * elements = [ imageUrl componentsSeparatedByString:@"/"];
                           
                           int number = [elements count];
                           
                           NSString * url = [NSString stringWithFormat:@"http://app.media.inaf.it/GetMediaImage.php?sourceYear=%@&sourceMonth=%@&sourceName=%@&width=748&height=361",[elements objectAtIndex:number-3],[elements objectAtIndex:number-2],[elements objectAtIndex:number-1]];
                           
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
                                                  
                                                  int orientation= [UIApplication sharedApplication].statusBarOrientation;
                                                  
                                                  
                                                  
                                                  if(orientation == 1 || orientation == 2)
                                                  {
                                                      [self.image setFrame:CGRectMake(10, 187, 748, 361)];
                                                      
                                                  }
                                                  else
                                                  {
                                                      if(orientation == 3 || orientation == 4)
                                                      {
                                                          [self.image setFrame:CGRectMake(243, 135, 538, 260)];
                                                          
                                                      }
                                                  }
                                                  
                                              });//end
                           }
                           
                        });//end
                       
        
        
        
    }
    else if([self.news.videos count] >0)
    {
        NSLog(@"load video");
        [self loadVideo];
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
