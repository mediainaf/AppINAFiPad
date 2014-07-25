//
//  ViewControllerFive.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 26/05/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ViewControllerFive.h"
#import "AppsViewController.h"
#import "JobsViewController.h"
#import "MapsViewController.h"
#import "EarthProjViewController.h"
#import "EarthProjectListViewController.h"
#import "SpaceProjViewController.h"
#import "TweetViewController.h"


@interface ViewControllerFive ()

@end

@implementation ViewControllerFive

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)deviceOrientationDidChangeNotification:(NSNotification*)note
{
    int orientation= [UIApplication sharedApplication].statusBarOrientation;
    
    
    if(orientation == 1 || orientation == 2)
    {
        self.sfondoView.image = [UIImage imageNamed:@"Assets/LBTPort.jpg"];
       // self.sfondoView.image = [UIImage imageNamed:@"Assets/VST_tramonto.jpg"];
      //  self.sfondoView.image = [UIImage imageNamed:@"Assets/galileoMore.jpg"];
        
    }
    else
    {
        if(orientation == 3 || orientation == 4)
        {
            self.sfondoView.image = [UIImage imageNamed:@"Assets/LBTLand.jpg"];
         //    self.sfondoView.image = [UIImage imageNamed:@"Assets/galileoMoreLand.jpg"];
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
     
        //self.sfondoView.image = [UIImage imageNamed:@"Assets/VST_tramonto.jpg"];
        self.sfondoView.image = [UIImage imageNamed:@"Assets/LBTPort.jpg"];
    }
    else
    {
        if(orientation == 3 || orientation == 4)
        {
            self.sfondoView.image = [UIImage imageNamed:@"Assets/LBTLand.jpg"];
           // self.sfondoView.image = [UIImage imageNamed:@"Assets/galileoMoreLand.jpg"];
        }
    }
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(deviceOrientationDidChangeNotification:)
     name:UIDeviceOrientationDidChangeNotification
     object:nil];

    self.title= @"More";
    [self.bottTweet setImage:[UIImage imageNamed:@"Assets/bottoneTweet.png"] forState:UIControlStateNormal];
    [self.bottApps setImage:[UIImage imageNamed:@"Assets/bottoneApps.png"] forState:UIControlStateNormal];
    [self.bottMaps setImage:[UIImage imageNamed:@"Assets/bottoneSedi.png"] forState:UIControlStateNormal];
    [self.bottJobs setImage:[UIImage imageNamed:@"Assets/bottoneJobs.png"] forState:UIControlStateNormal];
    [self.bottProgettiDaTerra setImage:[UIImage imageNamed:@"Assets/bottoneTelescopi.png"] forState:UIControlStateNormal];
    [self.bottProgettiSpaziali setImage:[UIImage imageNamed:@"Assets/bottoneSatelliti.png"] forState:UIControlStateNormal];

    
   // self.sfondoView.image = [UIImage imageNamed:@"Assets/galileoMore.jpg"];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openApps:(id)sender
{
    AppsViewController* apps = [[AppsViewController alloc] initWithNibName:@"AppsViewController" bundle:nil];
    
    [self.navigationController pushViewController:apps animated:YES];
}

- (IBAction)openMaps:(id)sender
{
    MapsViewController * maps = [[MapsViewController alloc] initWithNibName:@"MapsViewController" bundle:nil];
    
    [self.navigationController pushViewController:maps animated:YES];

}

- (IBAction)openJobs:(id)sender
{
    JobsViewController * jobs = [[JobsViewController alloc] initWithNibName:@"JobsViewController" bundle:nil];
    
    [self.navigationController pushViewController:jobs animated:YES];

}

- (IBAction)openProgettiSpaziali:(id)sender
{
    SpaceProjViewController * space = [[SpaceProjViewController alloc] initWithNibName:@"SpaceProjViewController" bundle:nil];
    
    [self.navigationController pushViewController:space animated:YES];
}

- (IBAction)shareTweet:(id)sender
{
    TweetViewController * tweet = [[TweetViewController alloc] initWithNibName:@"TweetViewController" bundle:nil];
    
    [self.navigationController pushViewController:tweet animated:YES];
      
}


- (IBAction)openProgettiDaTerra:(id)sender
{
    EarthProjectListViewController * earth = [[EarthProjectListViewController alloc] initWithNibName:@"EarthProjectListViewController" bundle:nil];
    
    [self.navigationController pushViewController:earth animated:YES];
    
}


@end
