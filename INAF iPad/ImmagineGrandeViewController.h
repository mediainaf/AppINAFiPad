//
//  ImmagineGrandeViewController.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 09/10/14.
//  Copyright (c) 2014 Nicolo' Parmiggiani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImmagineGrandeViewController : UIViewController <UIScrollViewDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate>

@property (nonatomic,strong) NSString * imageUrl;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;


@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;


@end
