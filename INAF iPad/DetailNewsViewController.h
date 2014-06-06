//
//  DetailNewsViewController.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 28/05/14.
//  Copyright (c) 2014 Nicolo' Parmiggiani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface DetailNewsViewController : UIViewController


@property (strong, nonatomic) IBOutlet UILabel *newsTitle;
@property (strong,nonatomic) News * news;
@property (strong, nonatomic) IBOutlet UILabel *summary;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UITextView *content;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UIImageView *sfondoView;
@property (strong, nonatomic) IBOutlet UILabel *author;


@end
