//
//  SpaceProjViewController.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 09/06/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <UIKit/UIKit.h>

@interface SpaceProjViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *sfondoView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
