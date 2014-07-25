//
//  ViewControllerInfo.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 26/05/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ViewControllerInfo.h"

@interface ViewControllerInfo ()

@end

@implementation ViewControllerInfo

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
            
            
            NSString *info = [d valueForKey:@"descr"];
            
            NSLog(@"%@",info);
            
            self.text.text = info;
            
            
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
