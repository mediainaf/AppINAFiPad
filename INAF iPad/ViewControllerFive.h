//
//  ViewControllerFive.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 26/05/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <UIKit/UIKit.h>

@interface ViewControllerFive : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *sfondoView;


@property (strong, nonatomic) IBOutlet UIButton *bottApps;
@property (strong, nonatomic) IBOutlet UIButton *bottMaps;
@property (strong, nonatomic) IBOutlet UIButton *bottJobs;
@property (strong, nonatomic) IBOutlet UIButton *bottProgettiDaTerra;
@property (strong, nonatomic) IBOutlet UIButton *bottProgettiSpaziali;


- (IBAction)openApps:(id)sender;
- (IBAction)openMaps:(id)sender;
- (IBAction)openJobs:(id)sender;
- (IBAction)openProgettiSpaziali:(id)sender;

- (IBAction)openProgettiDaTerra:(id)sender;

@end
