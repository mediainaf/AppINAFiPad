//
//  EarthProjectListViewController.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 24/07/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


#import <UIKit/UIKit.h>

@interface EarthProjectListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *sfondoView;

@end
