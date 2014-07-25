//
//  TweetViewController.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 25/07/14.
//  Copyright (c) 2014 Nicolo' Parmiggiani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetViewController : UIViewController <UIWebViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
