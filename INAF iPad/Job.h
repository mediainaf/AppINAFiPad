//
//  Job.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 26/05/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Foundation/Foundation.h>

@interface Job : NSObject


@property (nonatomic,strong) NSString * title ;
@property (nonatomic,strong) NSString * descriptionText ;
@property (nonatomic,strong) NSString * link ;
@property (nonatomic,strong) NSString * date;



@end
