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
    UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share",@"Open link", nil];
    [action showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
}
- (void)viewDidLoad
{
    
    
    UIBarButtonItem * apriImmagine = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action)];
    
    [self.navigationItem setRightBarButtonItem:apriImmagine animated:YES];

    
    //self.sfondoView.image = [UIImage imageNamed:@"Assets/galileo7.jpg"];
    self.sfondoView.alpha = 0.6;
    
    self.titleEvent.text = self.event.title;
    self.summary.text = self.event.summary;
    
    
    char const * s = [@"s"  UTF8String];
    
    
    
    dispatch_queue_t queue = dispatch_queue_create(s, 0);
    
    dispatch_async(queue, ^
                   {
                       NSString *url = [self.event.images objectAtIndex:0];
                       
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
    
    
    self.content.text = self.event.content;
    self.author.text = self.event.author;
    self.date.text = self.event.date;

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
