//
//  AppsViewController.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 27/05/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "AppsViewController.h"
#import "AppTableCell.h"

@interface AppsViewController ()
{
     int row;
}
@end

@implementation AppsViewController

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
       self.sfondoView.image = [UIImage imageNamed:@"Assets/cerisola1.jpg"];
        
    }
    else
    {
        if(orientation == 3 || orientation == 4)
        {
            self.sfondoView.image = [UIImage imageNamed:@"Assets/cerisolaLand.jpg"];        }
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
        
       self.sfondoView.image = [UIImage imageNamed:@"Assets/cerisola1.jpg"];
    }
    else
    {
        if(orientation == 3 || orientation == 4)
        {
           self.sfondoView.image = [UIImage imageNamed:@"Assets/cerisolaLand.jpg"];
        }
    }
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(deviceOrientationDidChangeNotification:)
     name:UIDeviceOrientationDidChangeNotification
     object:nil];

    self.title=@"Apps";
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
 

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    AppTableCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        cell= [[AppTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    /*
     NSLog(@"cel");
     cell.contentView.backgroundColor = [UIColor clearColor];
     cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
     cell.anteprima.text = @"Là dove osa Voyager 1";
     //  CGAffineTransform rotateImage = CGAffineTransformMakeRotation(M_PI_2);
     //cell.immaginePreview.transform = rotateImage;
     cell.immaginePreview.image = [UIImage imageNamed:@"Assets/thumb-ibex-150x150.jpg"];
     */
    if(indexPath.row==0)
    {
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
        cell.title.text = @"AGILEScience";
        cell.image.image = [UIImage imageNamed:@"Assets/agilescience.png"];
        cell.image.backgroundColor = [UIColor clearColor];
        
    }
    if(indexPath.row==1)
    {
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
        cell.title.text = @"Fermi Sky";
        cell.image.image = [UIImage imageNamed:@"Assets/fermisky.png"];
        cell.image.backgroundColor = [UIColor clearColor];
        
    }
    if(indexPath.row==2)
    {
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
        cell.title.text = @"Loss of the night";
        cell.image.image = [UIImage imageNamed:@"Assets/lossnight.png"];
        cell.image.backgroundColor = [UIColor clearColor];
        
    }
    
    return cell;
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1)
    {
        if(row==0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/it/app/agilescience/id587328264"]];
            
        }
        if(row==1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/fermi-sky/id436036936"]];
            
        }
        if(row==2)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://play.google.com/store/apps/details?id=com.cosalux.welovestars"]];
            
        }
        
        
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Attenzione" message:@"Stai per aprire il browser e uscire dall'applicazione. Desideri continuare?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"SI", nil];
    
    [alert show];
    
    row=indexPath.row;
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
