//
//  ViewControllerFive.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 26/05/14.
//  Copyright (c) 2014 Nicolo' Parmiggiani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerFive : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *sfondoView;


@property (strong, nonatomic) IBOutlet UIButton *bottApps;
@property (strong, nonatomic) IBOutlet UIButton *bottMaps;
@property (strong, nonatomic) IBOutlet UIButton *bottJobs;


- (IBAction)openApps:(id)sender;
- (IBAction)openMaps:(id)sender;
- (IBAction)openJobs:(id)sender;

@end
