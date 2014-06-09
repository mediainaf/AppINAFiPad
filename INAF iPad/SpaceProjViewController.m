//
//  SpaceProjViewController.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 09/06/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "SpaceProjViewController.h"
#import "SpaceMissionViewController.h"
#import "SpaceTableViewCell.h"

@interface SpaceProjViewController ()

@end

@implementation SpaceProjViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

NSArray * titoli;

- (void)viewDidLoad
{

    titoli = [NSArray arrayWithObjects:@"Soho",@"Cassini Huygens",@"Cluster",@"Mars Express",@"Rosetta",@"Mars Orbiter",@"Venus Express",@"Stereo",@"Dawn",@"Score", nil];
    
    self.title = @"Progetti Spaziali";
    self.sfondoView.image = [UIImage imageNamed:@"Assets/nebulaViola1.jpg"];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    SpaceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        cell= [[SpaceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    cell.title.text = [titoli objectAtIndex:indexPath.row];
    cell.thumbnail.image = [UIImage imageNamed:[NSString stringWithFormat:@"Assets/%d.jpg",indexPath.row+1]];
    cell.thumbnail.backgroundColor = [UIColor clearColor];
    
    
    
    return cell;
    

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SpaceMissionViewController * spaceMissionDetail = [[SpaceMissionViewController alloc] initWithNibName:@"SpaceMissionViewController" bundle:nil];
    
    [self.navigationController pushViewController:spaceMissionDetail animated:YES];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
     NSLog(@"seleziona");

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
