//
//  ViewControllerAnnotation.h
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 03/04/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <UIKit/UIKit.h>

@interface ViewControllerAnnotation : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *nome;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *link;



@property (strong, nonatomic) IBOutlet UILabel *phone;

@end
