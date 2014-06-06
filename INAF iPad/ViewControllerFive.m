//
//  ViewControllerFive.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 26/05/14.
//  Copyright (c) 2014 Nicolo' Parmiggiani. All rights reserved.
//

#import "ViewControllerFive.h"
#import "AppsViewController.h"
#import "JobsViewController.h"
#import "MapsViewController.h"



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

- (void)viewDidLoad
{
    self.title= @"More";
    
    [self.bottApps setImage:[UIImage imageNamed:@"Assets/bottoneApps.png"] forState:UIControlStateNormal];
    [self.bottMaps setImage:[UIImage imageNamed:@"Assets/bottoneMaps.png"] forState:UIControlStateNormal];
    [self.bottJobs setImage:[UIImage imageNamed:@"Assets/bottoneJobs.png"] forState:UIControlStateNormal];

    
    self.sfondoView.image = [UIImage imageNamed:@"Assets/galileoMore.jpg"];
    
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




@end
