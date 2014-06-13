//
//  WebcamCell.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 13/06/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


#import <UIKit/UIKit.h>

@interface WebcamCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *title;

@property (strong, nonatomic) IBOutlet UIImageView *webcam;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
