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
#import "InternetMoreViewController.h"
#import "App.h"

@interface AppsViewController ()
{
     int row;
    int load;
    NSMutableArray * apps;
    NSMutableDictionary * cachedImages;
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
-(void)viewDidAppear:(BOOL)animated
{
    if(load == 0)
    {
        load=1;
        
        NSString * url = [NSString stringWithFormat: @"http://app.media.inaf.it/GetApps.php"];
        
        NSString *response1 = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
        if(!response1)
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Error" message:@"Change internet settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        NSData * response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        
        NSLog(@"%@",url);
        
        NSArray *jsonArray ;
        if (response) {
            
            NSError *e = nil;
            jsonArray = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error: &e];
            
        }
        
        [apps removeAllObjects];
        
        for(NSDictionary * d in jsonArray)
        {
            
           
            
                NSString *name = [d valueForKey:@"name"];
                NSString *authors = [d valueForKey:@"authors"];
                NSString *iconURL = [d valueForKey:@"iconurl"];
                NSString *infoURL = [d valueForKey:@"infourl"];
                NSString *androidURL = [d valueForKey:@"androidurl"];
                NSString *iosURL = [d valueForKey:@"iosurl"];
                
                App * t = [[App alloc]init];
            
            NSLog(@"%@",iconURL);
                
                t.name=name;
                t.iconUrl=iconURL;
                t.iosURL=iosURL;
                t.androidURL= androidURL;
                t.infoURL=infoURL;
            
                [apps addObject:t];
            
        }
        
        [self.tableView reloadData];
        
    }

}
-(void)viewWillAppear:(BOOL)animated
{
    [self deviceOrientationDidChangeNotification:nil];
    
}

- (void)viewDidLoad
{
    load = 0;
    apps = [[NSMutableArray alloc] init];
    cachedImages = [[NSMutableDictionary alloc] init];
    
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
    
    return [apps count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    AppTableCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        cell= [[AppTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    //cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    
    if([apps count] >0)
    {
        
        
        App * s = [apps objectAtIndex:indexPath.row];
        
        cell.title.text = s.name;
        
        NSString *identifier = [NSString stringWithFormat:@"Cell%d" ,
                                indexPath.row];
        
        
        if([cachedImages objectForKey:identifier] != nil)
        {
            cell.image.image = [cachedImages valueForKey:identifier];
            //[cell.indicator stopAnimating];
            NSLog(@"metti immagine");
            
        }
        else
        {
            cell.image.image = nil;
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
            dispatch_async(queue, ^{
                //This is what you will load lazily
                
                NSData   *data = [NSData dataWithContentsOfURL:[NSURL URLWithString: s.iconUrl]];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    UIImage * image = [UIImage imageWithData:data];
                    
                    if(image != nil)
                    {
                        [cachedImages setObject:image forKey:identifier];
                        //cell.thumbnail.image = image;
                        [cell setNeedsLayout];
                        
                        [self.tableView beginUpdates];
                        
                        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        [self.tableView endUpdates];
                        
                        
                        
                    }
                    else
                    {
                        UIImage * image = [UIImage imageNamed:@"Assets/cameraIcon.png"];
                        [cachedImages setObject:image forKey:identifier];
                        
                        [cell setNeedsLayout];
                        [self.tableView beginUpdates];
                        
                        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        [self.tableView endUpdates];
                        
                        
                        
                        
                        
                        
                    }
                });
            });
            
        }
    }
    return cell;
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1)
    {
        
        App * a = [apps objectAtIndex:row];
        
        if(a.iosURL)
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:a.iosURL]];
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attenzione" message:@"Questa applicazione non è disponibile per iOS" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
            
        
    }
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex ==0)
    {
        
        
        InternetMoreViewController * internet = [[InternetMoreViewController alloc] initWithNibName:@"InternetMoreViewController" bundle:nil];
        
        App * a = [apps objectAtIndex:row];
        
        
        if(a.infoURL)
        {
            internet.url = a.infoURL;
        
            [self.navigationController pushViewController:internet animated:YES];
        }
    }
    if(buttonIndex == 1)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Attenzione" message:@"Stai per aprire il browser e uscire dall'applicazione. Desideri continuare?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"SI", nil];
        
        [alert show];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Attenzione" message:@"Stai per aprire il browser e uscire dall'applicazione. Desideri continuare?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"SI", nil];
    
    [alert show];
     */
     row=indexPath.row;

     
    
    UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open Info",@"Download App", nil];
    
    [action showInView:self.view];
    
    
    
    
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
