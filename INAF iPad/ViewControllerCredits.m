//
//  ViewControllerCredits.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 26/05/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ViewControllerCredits.h"

@interface ViewControllerCredits ()

@end

@implementation ViewControllerCredits

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
    NSData * response = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://app.media.inaf.it/GetAbout.php"]];
    
    if (response)
    {
        NSArray * jsonArray;
        
        NSError *e = nil;
        jsonArray = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error: &e];
        
        
        for(NSDictionary * d in jsonArray)
        {
            
            
            NSString *info = [d valueForKey:@"credits"];
            
            NSLog(@"%@",info);
            
            self.text.text = [NSString stringWithFormat:@"%@ \n\nVersione 1.1.0",info];
            
        }

        
        
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Error" message:@"Change internet settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    

}
- (void)viewDidLoad
{
    UIDevice * device = [UIDevice currentDevice];
    
    if( [device.systemVersion hasPrefix:@"6"])
    {
        self.navBar.barStyle = UIBarStyleBlackOpaque;
        
    }

    
        [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
