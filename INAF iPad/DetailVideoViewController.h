//
//  DetailVideoViewController.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 26/05/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <UIKit/UIKit.h>
#import "Video.h"

@interface DetailVideoViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property(nonatomic,strong) Video * video;
@property (nonatomic,strong) UIImage * thumbnail;
@property (strong, nonatomic) IBOutlet UIImageView *sfondoView;
@property (strong, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (strong, nonatomic) IBOutlet UITextView *descriptionText;
@property (strong, nonatomic) IBOutlet UILabel *data;

@property (strong, nonatomic) IBOutlet UILabel *numberOfView;
@property (strong, nonatomic) IBOutlet UIImageView *play;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
