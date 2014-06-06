//
//  DetailVideoViewController.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 26/05/14.
//  Copyright (c) 2014 Nicolo' Parmiggiani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Video.h"

@interface DetailVideoViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property(nonatomic,strong) Video * video;
@property (nonatomic,strong) UIImage * thumbnail;
@property (strong, nonatomic) IBOutlet UIImageView *sfondoView;
@property (strong, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (strong, nonatomic) IBOutlet UITextView *description;
@property (strong, nonatomic) IBOutlet UILabel *data;

@property (strong, nonatomic) IBOutlet UILabel *numberOfView;
@property (strong, nonatomic) IBOutlet UIImageView *play;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
