//
//  ViewControllerInfo.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 26/05/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <UIKit/UIKit.h>

@interface ViewControllerInfo : UIViewController
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *text;

@end
