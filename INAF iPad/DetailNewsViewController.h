//
//  DetailNewsViewController.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 28/05/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <UIKit/UIKit.h>
#import "News.h"

@interface DetailNewsViewController : UIViewController <UIWebViewDelegate>


@property (strong, nonatomic) IBOutlet UILabel *newsTitle;
@property (strong,nonatomic) News * news;
@property (strong, nonatomic) IBOutlet UILabel *summary;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UITextView *content;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UIImageView *sfondoView;
@property (strong, nonatomic) IBOutlet UILabel *author;
@property (strong, nonatomic) IBOutlet UIWebView *webView;


@end
