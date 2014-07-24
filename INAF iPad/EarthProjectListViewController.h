//
//  EarthProjectListViewController.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 24/07/14.
//  Copyright (c) 2014 Nicolo' Parmiggiani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EarthProjectListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *sfondoView;

@end
